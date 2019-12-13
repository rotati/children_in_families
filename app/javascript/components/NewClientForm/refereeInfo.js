import React       from 'react'
import {
  SelectInput,
  TextInput,
  Checkbox
}                   from '../Commons/inputs'
import Address      from './address'

export default props => {
  const { onChange, data: { referee, client, currentProvinces, referralSourceCategory, referralSource, currentDistricts, currentCommunes, currentVillages, birthProvinces, errorFields} } = props

  const genderLists = [{label: 'Female', value: 'female'}, {label: 'Male', value: 'male'}, {label: 'Other', value: 'other'}, {label: 'Unknown', value: 'unknown'}]

  const referralSourceCategoryLists = referralSourceCategory.map(category => ({label: category[0], value: category[1]}))
  const referralSourceLists = referralSource.filter(source => source.ancestry !== null && source.ancestry == client.referral_source_category_id).map(source => ({label: source.name, value: source.id}))

  const onReferralSourceCategoryChange = data => {
    onChange('client', { referral_source_category_id: data.data, referral_source_id: null })({type: 'select'})
  }

  return (
    <div className="containerClass">
      <legend>
        <div className="row">
          <div className="col-xs-12 col-md-6 col-lg-3">
            <p>Referee Information</p>
          </div>
        </div>
      </legend>

      <div className="row">
        <div className="col-xs-12 col-sm-6 col-md-3">
          <Checkbox label="Anonymous Referee" checked={referee.anonymous || false} onChange={onChange('referee', 'anonymous')} />
        </div>
      </div>
      <br/>
      <div className="row">
        <div className="col-xs-12 col-md-6 col-lg-3">
          <TextInput
            required
            // isError={errorFields.includes('referee_name')}
            isError={errorFields.includes('name_of_referee')}
            value={client.name_of_referee}
            label="Name"
            // onChange={onChange('referee', 'referee_name')}
            onChange={onChange('client', 'name_of_referee')}
          />
        </div>
        <div className="col-xs-12 col-md-6 col-lg-3">
          <SelectInput label="Gender" options={genderLists} onChange={onChange('referee', 'gender')} value={referee.gender} />
        </div>
      </div>
      <div className="row">
        <div className="col-xs-12 col-md-6 col-lg-3">
          <TextInput label="Referee Phone Number" onChange={onChange('client', 'referral_phone')} value={client.referral_phone} />
        </div>
        <div className="col-xs-12 col-md-6 col-lg-3">
          <TextInput label="Referee Email Address" onChange={onChange('referee', 'email')} value={referee.email} />
        </div>
        <div className="col-xs-12 col-md-6 col-lg-3">
          <SelectInput
            required
            isError={errorFields.includes('referral_source_category_id')}
            label="Referral Source Catgeory"
            options={referralSourceCategoryLists}
            value={client.referral_source_category_id}
            onChange={onReferralSourceCategoryChange}
          />
        </div>
        <div className="col-xs-12 col-md-6 col-lg-3">
          <SelectInput
            options={referralSourceLists}
            label="Referral Source"
            onChange={onChange('client', 'referral_source_id')}
            value={client.referral_source_id}
          />
        </div>
      </div>
      <legend>
        <div className="row">
          <div className="col-xs-12 col-md-6 col-lg-3">
            <p>Address</p>
          </div>
          <div className="col-xs-12 col-md-6 col-lg-3">
            <Checkbox label="Outside Cambodia" checked={referee.outside || false} onChange={onChange('referee', 'outside')} />
          </div>
        </div>
      </legend>

      <Address outside={referee.outside || false} onChange={onChange} data={{currentDistricts, currentCommunes, currentVillages, currentProvinces, objectKey: 'referee', objectData: referee}} />
    </div>
  )
}