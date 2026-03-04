interface SkillTagProps {
  name: string;
}

const SkillTag = ({ name }: SkillTagProps) => (
  <span style={{
    background: '#333',
    padding: '5px 12px',
    borderRadius: '20px',
    fontSize: '0.75rem',
    border: '1px solid #444'
  }}>
    {name}
  </span>
);

export default SkillTag;