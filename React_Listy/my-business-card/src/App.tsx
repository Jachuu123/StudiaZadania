import './App.css';
import CardContainer from './components/CardContainer';
import Profile from './components/Profile'; // This should contain Avatar + Identity
import About from './components/About';
import ContactSection from './components/ContactSection';
import ContactItem from './components/ContactItem';
import SkillsList from './components/SkillsList'; // This should now map using SkillTag

function App() {
  const mySkills = ["React", "TypeScript", "Vite", "Node.js", "CSS"];

  return (
    <CardContainer>
      <Profile 
        name="Jan Kowalski" 
        title="Frontend Developer" 
        image="https://i.pravatar.cc/150?u=jan" 
      />
      
      <About text="Computer Science student at UWr. Passionate about building clean, modular React applications using TypeScript." />

      <ContactSection>
        <ContactItem icon="📧" value="jan.k@uwr.edu.pl" />
        <ContactItem icon="📞" value="+48 000 000 000" />
      </ContactSection>

      <SkillsList skills={mySkills} />
    </CardContainer>
  );
}

export default App;