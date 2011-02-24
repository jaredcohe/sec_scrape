class SecFormBody
# for getting data from the body of the SEC Form D
# sample link to form => http://www.sec.gov/Archives/edgar/data/1439404/000143940410000003/primary_doc.xml

  attr_accessor(:cik, :entity_name, :issuer_street1, :issuer_street2, :city,
      :state_or_country, :state_or_country_description, :jurisdiction_of_incorporation,
      :issuer_previous_name, :edgar_Previous_Name_List, :year_of_incorporation,
      :industry_group, :type_of_filing, :date_of_first_sale, :equity, :option_to_acquire,
      :business_combination, :company_raised_amount, :company_offering_amount, :signature_date)

  def initialize(form_url)
    @document = Nokogiri::XML(open(form_url)).remove_namespaces!
  end

  def extract_data_from_form_body
    @cik = extract('//edgarSubmission/primaryIssuer/cik')
    @entity_name = extract('//edgarSubmission/primaryIssuer/entityName')
    @issuer_street1 = extract('//edgarSubmission/primaryIssuer/issuerAddress/street1')
    @issuer_street2 = extract('//edgarSubmission/primaryIssuer/issuerAddress/street2')
    @city = extract('//edgarSubmission/primaryIssuer/issuerAddress/city')
    @state_or_country = extract('//edgarSubmission/primaryIssuer/issuerAddress/stateOrCountry')
    @state_or_country_description = extract('//edgarSubmission/primaryIssuer/issuerAddress/stateOrCountryDescription')
    @jurisdiction_of_incorporation = extract('//edgarSubmission/primaryIssuer/jurisdictionOfInc')
    @issuer_previous_name = extract('//edgarSubmission/primaryIssuer/issuerPreviousNameList/value')
    @edgar_Previous_Name_List = extract('//edgarSubmission/primaryIssuer/edgarPreviousNameList/value')
    @year_of_incorporation = extract('//edgarSubmission/primaryIssuer/yearOfInc/overFiveYears')
    @industry_group = extract('//edgarSubmission/offeringData/industryGroup/industryGroupType')
    @type_of_filing = extract('//edgarSubmission/offeringData/typeOfFiling/newOrAmendment')
    @date_of_first_sale = extract('//edgarSubmission/offeringData/typeOfFiling/dateOfFirstSale')
    @equity = extract('//edgarSubmission/offeringData/typesOfSecuritiesOffered/isEquityType')
    @option_to_acquire = extract('//edgarSubmission/offeringData/typesOfSecuritiesOffered/isOptionToAcquireType')
    @business_combination = extract('//edgarSubmission/offeringData/businessCombinationTransaction/isBusinessCombinationTransaction')
    @company_raised_amount = extract('//edgarSubmission/offeringData/offeringSalesAmounts/totalAmountSold')
    @company_offering_amount = extract('//edgarSubmission/offeringData/offeringSalesAmounts/totalOfferingAmount')
    @signature_date = extract('//edgarSubmission/offeringData/signatureBlock/signature/signatureDate')
  end

  def extract(path)
      @document.xpath(path).text.strip.gsub(/\n/, "")
  end

end