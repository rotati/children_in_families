import React from 'react'

export default props => {
  const { isError, label, required, onChange } = props
  return (
    <div className='form-group'>
      <label style={isError && styles.errorText || {}}>
        { required && <abbr title='required'>* </abbr> }
        {label}
      </label>
      <input
        className='form-control'
        onChange={onChange}
        style={
          Object.assign({},
            isError && styles.errorInput,
          )
        }
      />
      { isError && <span style={styles.errorText}>Cannot be blank.</span> }
    </div>
  )
}

const styles = {
  errorText: {
    color: 'red'
  },
  errorInput: {
    borderColor: 'red'
  },
}
