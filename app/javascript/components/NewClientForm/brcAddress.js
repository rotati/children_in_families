import React, { useState, useEffect } from 'react'
import {
  TextInput,
  SelectInput,
  TextArea
} from '../Commons/inputs'
import { t } from '../../utils/i18n'

export default props => {
  const { onChange, disabled, translation, fieldsVisibility,
          data: { client, objectKey, objectData, T, current_organization, settlements, brc_address, brc_islands, brc_household_types, brc_resident_types }
        } = props

  const [settlementList, setSettlementList] =  useState(settlements && settlements.map(settlement  => ({label: settlement, value: settlement})))
  const [brcIslands, setBrcIslands] = useState(brc_islands && brc_islands.map(island  => ({label: island, value: island})))
  const [brcHouseholdTypes, setBrcHouseholdTypes] = useState(brc_household_types && brc_household_types.map(household  => ({label: household, value: household})))
  const [brcResidentTypes, setBrcResidentTypes] = useState(brc_resident_types && brc_resident_types.map(type  => ({label: type, value: type})))

  return (
    <div>
      {
        fieldsVisibility.brc_client_address == true &&
        <legend className="brc-address">
          <div className="row">
            <div className="col-xs-12 col-md-6 col-lg-6">
              <p>Current Address</p>
            </div>
          </div>
        </legend>
      }

      <div className="row">
        {
          fieldsVisibility.current_island == true &&
          <div className="col-xs-12 col-md-6 col-lg-4" style={{ maxHeight: '59px' }}>
            <SelectInput
              label={translation.clients.form['current_island']}
              options={brcIslands}
              isDisabled={disabled}
              onChange={onChange(objectKey, 'current_island')}
              value={objectData.current_island}
            />
          </div>
        }

        {
          fieldsVisibility.current_street == true &&
          <div className="col-xs-12 col-md-6 col-lg-4">
            <TextInput
              label={translation.clients.form['current_street']}
              disabled={disabled}
              onChange={onChange(objectKey, 'current_street')}
              value={objectData.current_street}
            />
          </div>
        }

        {
          fieldsVisibility.current_po_box == true &&
          <div className="col-xs-12 col-md-6 col-lg-4">
            <TextInput
              label={translation.clients.form['current_po_box']}
              disabled={disabled}
              onChange={onChange(objectKey, 'current_po_box')}
              value={objectData.current_po_box}
            />
          </div>
        }
      </div>
      <div className="row">
        {
          fieldsVisibility.current_city == true &&
          <div className="col-xs-12 col-md-6 col-lg-4">
            <TextInput
              label={translation.clients.form['current_city']}
              disabled={disabled}
              onChange={onChange(objectKey, 'current_city')}
              value={objectData.current_city}
            />
          </div>
        }

        {
          fieldsVisibility.current_settlement == true &&
          <div className="col-xs-12 col-md-6 col-lg-4">
            <SelectInput
              label={translation.clients.form['current_settlement']}
              disabled={disabled}
              options={settlementList}
              onChange={onChange(objectKey, 'current_settlement')}
              value={objectData.current_settlement}
            />
          </div>
        }

        {
          fieldsVisibility.current_resident_own_or_rent == true &&
          <div className="col-xs-12 col-md-6 col-lg-4" style={{ maxHeight: '59px' }}>
            <SelectInput
              label={translation.clients.form['current_resident_own_or_rent']}
              disabled={disabled}
              options={brcResidentTypes}
              onChange={onChange(objectKey, 'current_resident_own_or_rent')}
              value={objectData.current_resident_own_or_rent}
            />
          </div>
        }
      </div>
      <div className="row">
        {
          fieldsVisibility.current_household_type == true &&
          <div className="col-xs-12 col-md-6" style={{ maxHeight: '59px' }}>
            <SelectInput
              label={translation.clients.form['current_household_type']}
              disabled={disabled}
              options={brcHouseholdTypes}
              onChange={onChange(objectKey, 'current_household_type')}
              value={objectData.current_household_type}
            />
          </div>
        }
      </div>

      {
        fieldsVisibility.brc_client_other_address == true &&
        <legend className="brc-address">
          <div className="row">
            <div className="col-xs-12 col-md-6 col-lg-6">
              <p>Other Address</p>
            </div>
          </div>
        </legend>
      }

      <div className="row">

        {
          fieldsVisibility.island2 == true &&
          <div className="col-xs-12 col-md-12 col-lg-4">
            <SelectInput
              label={translation.clients.form['island2']}
              options={brcIslands}
              isDisabled={disabled}
              onChange={onChange(objectKey, 'island2')}
              value={objectData.island2}
            />
          </div>
        }

        {
          fieldsVisibility.street2 == true &&
          <div className="col-xs-12 col-md-6 col-lg-4">
            <TextInput
              label={translation.clients.form['street2']}
              disabled={disabled}
              onChange={onChange(objectKey, 'street2')}
              value={objectData.street2}
            />
          </div>
        }

        {
          fieldsVisibility.po_box2 == true &&
          <div className="col-xs-12 col-md-6 col-lg-4">
            <TextInput
              label={translation.clients.form['po_box2']}
              disabled={disabled}
              onChange={onChange(objectKey, 'po_box2')}
              value={objectData.po_box2}
            />
          </div>
        }

      </div>
      <div className="row">
        {
          fieldsVisibility.city2 == true &&
          <div className="col-xs-12 col-md-6 col-lg-4">
            <TextInput
              label={translation.clients.form['city2']}
              disabled={disabled}
              onChange={onChange(objectKey, 'city2')}
              value={objectData.city2}
            />
          </div>
        }

        {
          fieldsVisibility.settlement2 == true &&
          <div className="col-xs-12 col-md-6 col-lg-4">
            <SelectInput
              label={translation.clients.form['settlement2']}
              disabled={disabled}
              options={settlementList}
              onChange={onChange(objectKey, 'settlement2')}
              value={objectData.settlement2}
            />
          </div>
        }

        {
          fieldsVisibility.resident_own_or_rent2 == true &&
          <div className="col-xs-12 col-md-6 col-lg-4">
            <SelectInput
              label={translation.clients.form['resident_own_or_rent2']}
              disabled={disabled}
              options={brcResidentTypes}
              onChange={onChange(objectKey, 'resident_own_or_rent2')}
              value={objectData.resident_own_or_rent2}
            />
          </div>
        }
      </div>
      <div className="row">
        {
          fieldsVisibility.household_type2 == true &&
          <div className="col-xs-12 col-md-6 col-lg-6">
            <SelectInput
              label={translation.clients.form['household_type2']}
              disabled={disabled}
              options={brcHouseholdTypes}
              onChange={onChange(objectKey, 'household_type2')}
              value={objectData.household_type2}
            />
          </div>
        }
      </div>
    </div>
  )
}
