import React, { useState } from 'react'
import AdministrativeInfo from './admin'
import RefereeInfo from './refereeInfo'
import ReferralInfo from './referralInfo'
import ReferralMoreInfo from './referralMoreInfo'
import ReferralVulnerability from './referralVulnerability'
import './styles.scss'
import { type } from 'os'

const Forms = props => {
  const {
    data: {
      client, users, birthProvinces, referralSource, referralSourceCategory, selectedCountry, internationalReferredClient
    }
  } = props
  const [step, setStep] = useState(1)
  const [clientData, setclientData] = useState(client)
  const [refereeData, setrefereeData] = useState({})

  const gettingStartData = { client, users, birthProvinces, referralSourceCategory, referralSource, selectedCountry, internationalReferredClient }

  const tabs = [
    {text: 'Referee Information', step: 1},
    {text: 'Client / Referral Information', step: 2},
    {text: 'Client / Referral - More Information', step: 3},
    {text: 'Client / Referral - Vulnerability Information and Referral Note', step: 4}
  ]

  const activeClass = value => step === value ? 'active' : ''

  const renderTab = (data, index) => {
    return (
      <span
        key={index}
        onClick={() => setStep(data.step)}
        className={`tabButton ${activeClass(data.step)}`}
      >
        {data.text}
      </span>
    )
  }

  const onChange = (obj, field) => event => {
    const value = typeof event === 'object' &&  event.target.value || event

    switch (obj) {
      case 'client':
        setclientData({...clientData, [field]: value })
        break;
      case 'referee':
        setrefereeData({...refereeData, [field]: value })
        break;
    }
  }

  console.log('clientData', clientData)
  console.log('refereeData', refereeData)

  return (
    <div className='container'>
      <div className='tabHead'>
        {tabs.map((tab, index) => renderTab(tab, index))}
      </div>

      <div className='contentWrapper'>
        <div className='leftComponent'>
          <AdministrativeInfo data={gettingStartData} onChange={onChange} />
        </div>

        <div className='rightComponent'>
          <div style={{display: step === 1 ? 'block' : 'none'}}>
            <RefereeInfo data={gettingStartData} onChange={onChange} />
          </div>

          <div style={{display: step === 2 ? 'block' : 'none'}}>
            <ReferralInfo data={gettingStartData} onChange={onChange} />
          </div>

          <div style={{ display: step === 3 ? 'block' : 'none' }}>
            <ReferralMoreInfo data={gettingStartData} onChange={onChange} />
          </div>

          <div style={{ display: step === 4 ? 'block' : 'none' }}>
            <ReferralVulnerability data={gettingStartData} onChange={onChange} />
          </div>
        </div>
      </div>

      <div className='actionfooter'>
        <div className='leftWrapper'>
          <span className='btn btn-default'>Cancel</span>
        </div>

        <div className='rightWrapper'>
          <span className='previousButton'>Previous</span>
          <span className='nextButton'>Next</span>
        </div>
      </div>
    </div>
  )
}

export default Forms
