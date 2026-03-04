import SkillTag from './SkillTag';

interface SkillsListProps {
  skills: string[];
}

const SkillsList = ({ skills }: SkillsListProps) => (
  <div style={{ marginTop: '20px', textAlign: 'left' }}>
    <h3 style={{ fontSize: '1rem', borderBottom: '1px solid #333', paddingBottom: '5px' }}>Skills</h3>
    <div style={{ display: 'flex', flexWrap: 'wrap', gap: '8px', marginTop: '10px' }}>
      {skills.map((skill) => (
        <SkillTag key={skill} name={skill} />
      ))}
    </div>
  </div>
);

export default SkillsList;