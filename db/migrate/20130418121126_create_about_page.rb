class CreateAboutPage < ActiveRecord::Migration
  def up
    page = Page.create({:title => "About", :slug => "about"})
    
    CustomField.create({
                         :page_id => page.id, 
                         :slug => "about_us",
                         :label => "About Us", 
                         :content => "About Us",
                         :menu_order => 1, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "overview",
                         :label => "Overview", 
                         :content => "<h4>Overview</h4>
            <h5>About Us: BabyFolio</h5>
            <p>Just like snowflakes, children are unique. BabyFolio helps parents discover what is special about their baby and where their baby is developmentally. It then provides tips, activities and resources tailored to who their baby is and what their baby is working on. Baby Folio helps you to get to know your baby and provides the right play at the right time.</p>
            <h5>Our Mission</h5>
            <p>We help baby.s thrive.<br>
              Every day, every moment of their lives, our children are learning and developing. They are wired to learn and thrive in this world. BabyFolio makes this ongoing and subtle learning more visible so parents can see more and be more responsive-- so parents can partner with their children, learning about them and helping them learn.
            </p>
            <p>Our goal is to enable parents to better understand their unique baby and provide more responsive and individualized support so that their baby gets the best possible start. We do this by promoting real engagement and wonderful play between parents and babies as they build strong and intimate relationships. BabyFolio instills confidence and peace of mind for parents because they know that they are doing the best they can for their baby.</p>
            

            <br><h5>What we do</h5>
            <p><span class='bold'>Zero in on what matters most</span> - We ACT on the understanding that every baby is different. BabyFolio empowers parents to identify the most important developments in their baby.s life. We call these .Learning Windows. because babies go through sensitive periods when they are wired to learn and eager to exercise their budding competences. We then offer tailored tips, activities, and resources so those babies build the strongest foundations possible-- the right play at the right time.</p>
            <p><span class='bold'>Engage a close-knit social network</span> - We enable parents to engage the .village. of people that spend time with and care about their baby. That way, everyone who is involved in the baby.s life  can learn from and contribute to a better understanding of who this precious person is. Everyone can then better support the baby.s optimal learning and development.</p>
            <p><span class='bold'>Build a lasting archive and record</span> &ndash; BabyFolio accumulates interesting and insightful information effortlessly while helping guide parents and caregivers on what matters most for them to be doing and by engaging the baby.s social network.  The result is an amazing .21st century. babybook shining a light on meaningful patterns that develop over time.</p>",
                         :menu_order => 1, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "how_it_works",
                         :label => "How It Works", 
                         :content => "<h4>How It Works</h4>
            <p class=\"paragraph p1\"><span class=\"bold\">Start with what your baby is doing- their actual behaviors</span> - Baby-Folio first asks you to <span class=\"bold\">.Reflect.</span> on the specific behaviors you have seen your child perform across important developmental areas such as language, logic &amp; numbers, and social development. For example, if your child is 9 months old, we might ask if you have seen your baby pointing at things yet. We do not assume all babies are doing the same thing at the same age; we understand that there is a broad range around any given milestone or developmental behavior as to when it may occur. We have developed the tools to help you figure out and interpret exactly what your baby is doing and when so that we can tailor our tips for you.</p>
            <p class=\"paragraph p2\"><span class=\"bold\">Take advantage of your child.s important .learning windows..</span> Once we have zeroed in on the pace of important developments or active .learning windows., we provide <span class=\"bold\">.Play.</span> ideas and activities to enrich those developments and provide the strongest foundations possible. These learning windows are sensitive periods where your child is wired to learn and eager to exercise their newfound skills and interests. Engaging in <span class=\"bold\">Quality Play</span> experiences when your baby.s interest is highest in developing a particular skill will strengthen learning and lays a foundation for robust future development.</p>
            <p class=\"paragraph p3\"><span class=\"bold\">Catch the next set of .learning windows. at the right time.</span> In addition to supporting current learning windows, BabyFolio signals you to <span class=\"bold\">.Watch.</span> for the next set of natural development behaviors that will be on the horizon. We provide information about the learning windows so that you can better understand why they are so important to that area of development. We bring to your attention the behaviors that may follow their current developments and ask you to identify them when they start so that we can begin a new set of <span class=\"bold\">Quality Play</span> activities at just the right time.</p>
            <p class=\"paragraph p4\"><span class=\"bold\">Better understand your baby and enlist the right support</span> from your social network. By posting observations about the behaviors you have seen and what you are doing, the <span class=\"bold\">.Timeline.</span> helps you capture and share your baby.s development over time and share it with others who have an interest. The timeline not only provides a nice record of your baby.s development but is also an excellent place for people who spend time with or care about your baby to share their insights and thoughts.</p>",
                         :menu_order => 1, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "parenting_manifesto",
                         :label => "Parenting Manifesto", 
                         :content => "<h4>Parenting Manifesto</h4>
          <p>How do we as parents love and enjoy our babies while taking on the awesome responsibility of raising them? How do we help our little ones realize all the hopes and dreams we have for them and that they will eventually have for themselves? Research is clear: we truly are our children.s first and most important teachers. We need to take an active role in the education of our children. The question is what does this mean? How do we provide the best possible start-- the best foundations for life? The challenge is that there is no one right or simple answer. Guidance is available, but we really need to take this challenge on and figure it out for ourselves. Each of us is different and each of our babies is different. An .active role. should look different for each parent and each child and in different situations. We as parents need to develop and refine our judgment about what is .best..</p>

          <p>Guidance frequently swings between extreme views:</p>
          <ul class='content-ul'>
            <li>Strict traditional practices with an adult-centered approach of shaping what our children know, can do or be,</li>
            <li>Or the opposite, open progressive practices with a child-centered and hands off approach of letting them develop on their own.</li>
          </ul>
          <p>However, research and science points the way to a middle path. Of course, the child comes into this world as a unique individual with their own genetic potentialities. And of course, parents and experiences make a difference for our child.s learning and development and how their potentialities get realized and thrive. Each child is different and we need to experiment and find that path that works best for them.</p>
          <p>As the famous poet Yeats once said .Education is not the filling of a pail but the lighting of a fire..  In fact the the original meaning of the Latin word \"educere\", the word from which the English word education is derived, is \"to lead out, to bring out, to elicit, to draw forth..  Education was a lifelong process of drawing forth from each person the full potential that lay within them.</p>
          <p>As the adults and as a society,  we do have a reasonable idea of what is important (3Rs, Critical &amp; Creative Reasoning) but we need to balance that with the deeper cultivation of who our children truly are. To quote Albert Einstein: .Everybody is a genius. But if you judge a fish by its ability to climb a tree, it will live its whole life believing that it is stupid.. We need to transform our conceptions of what success and successful parenting is.</p>
          <p>To help our little ones get the best start in life and be the best parents we can be, we need to start with ourselves-- to focus on our own .parent development.. Children thrive when their parents thrive. We cannot let go of our own interests and passions that make us who we are. We also need to dig down deep and examine our own motivations, ambitions and distortions. Of course we all want our children to grow up to have fulfilling and meaningful lives. To do that we need to harness our fears about our children.s futures, shift our focus from the excesses of hyper-parenting, our preoccupation with keeping up with the Jones and comparing our kids on a narrow set of behavior and performances and an unhealthy reliance on having our kids provide status and meaning in our own lives. It is not easy work, as we are usually most blind to our own faults. But if we are willing to be both reflective and honest, we CAN create wonderful environments and homes that help our children thrive.</p>
          <p>The whole process needs to start with the question: Who is my child? All children are born wired to learn about and master their world. However, anyone with two or more children knows that every child is different and engages with their world in unique ways. Some minds are wired to create symphonies; others are disposed to build bridges or computers; or to cure medical ailments. Different kinds of minds and hearts are destined to lead different adult lives.</p>
          <p>Minds give off little signals that reveal what they are if we listen and observe. We as the adults and caregivers in a child.s life have a dramatic influence on how this development and plot plays out. Research has shown that a baby.s brain grows in size from 20% at birth to more than 80% between 3 and 5 years. This growth results from the more than 100 trillion connections that are being formed among a child.s one billion neurons. These connections set the foundation for a child.s mental architecture of skills, dispositions and understandings. These foundations last a lifetime, so we want to provide the best start possible. Hopefully we help our children to shape and build their profile of strengths and to discover and engage in good matches between their kind of mind and their life.s experiences and opportunities.</p>
          <p>BabyFolio brings you the state of the art research on learning and development and helps you put it to work for your specific child&mdash;to discover and nurture your child.s specific genius, discovering the unique profile and nurturing their specific learning and development needs at the right time. The idea is that .We know development. You know your child. Together we can realize your child.s full potential.. Let.s get started!</p>",
                         :menu_order => 1, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "role_of_research",
                         :label => "Role Of Research", 
                         :content => "<h4>The Role of Research</h4>
          <p>With the explosion of research on child development, the knowledge base of how to best support our children.s development is constantly expanding.  A fundamental lesson from this research is that children are actively trying to make sense of their world and that they create understandings or theories as they live their lives.   In fact, research emphasizes the importance of what children learn from their day-to-day experiences.  We now have a better understanding about what is happening in children.s minds in order to know how they are making sense of their experiences.  Learning is an interaction between children and their environment.  There are a number of things we can do to provide children with stimulating, rich environments.  This research helps parents understand their children better &ndash; leading to a potentially happier and healthier childhood with opportunities for learning.</p>
          <p>We worked with researchers at some of the world.s leading universities (Harvard, the Brazelton Institute, Columbia University, Reggio Emilia), culminating in an encyclopedia of the best research for the newborn through five-year-old period of development.  We monitor and keep on top of this research and deliver this knowledge to parents so they can apply it in their daily activities.  We know parents are busy so we research the information for them and provide in a way that is tailored to their child.  This way, parents can focus on what.s truly important to them &ndash; their individual child.s learning and development.</p>",
                         :menu_order => 1, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "whats_different",
                         :label => "Whats different", 
                         :content => "<h4>What.s Different?</h4>
          <p>So what sets BabyFolio apart?  Our site focuses on the one child you care most about-- your own! No other app tailors and personalizes resources and guidance based on your child.s ACTUAL behaviors.  General .age &amp; stage. content, based on your child.s age, misses the mark. Research is clear that every baby is different and that there is a very broad timeframe for which any given behavior will normally emerge. BabyFolio cuts through the clutter to identify the most important developments occurring right now so you can provide the .right play at the right time.. </p>
          <p>We also make it easy to engage your spouse and close-knit social network who spend the most time with your baby, so that they also can better understand and better support your unique child. As you work with BabyFolio and your baby, we automatically generate an archive, a 21st century babybook, of your babies behaviors over time which you can reflect and build upon. This enables greater insight into who your unique baby is. You will see more and be able to better support your child.s learning career. Its a partnership, we know development, bringing you the state of the art research on learning and development; and you know your child, spending more time with them than anyone else, together we can best put the world.s knowledge and resources  to work for your specific child&mdash;to discover and nurture your child.s specific genius, discovering the unique profile and nurturing their specific learning and development needs at the right time. </p>",
                         :menu_order => 1, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "multiple_intelligences",
                         :label => "Multiple Intelligences", 
                         :content => "<h4>Multiple Intelligences:</h4>
          <p><span class='bold underline'>Language Intelligence:</span> This intelligence includes our understanding of the meanings of words and the grammatical structure of language, the effect of language upon others as well as how we react to the way language sounds.  Some examples can be an infant.s babbling or a preschooler.s narrative storytelling.</p>
          <p><span class='bold underline'>Logic Intelligence:</span> This area reflects our ability to approach problems using logical or step-by-step reasoning, our understanding of patterns and organization and how we assess and keep track of the world of objects.  Here, examples include an infant showing interest in his or her toys by observing, touching or banging them and a toddler ordering objects into piles and groups.</p>
          <p><span class=\"bold underline\">Social Intelligence:</span>  As we are constantly interacting with people, this area focuses on our relationships with each other and the world around us.   Our ability to acknowledge and be aware of others &ndash; their needs, abilities, moods and being able to distinguish between them helps us to form meaningful relations.  An example of this could be an infant crying when he or she hears another baby crying or a toddler talking about his or her friend.s feelings.</p>
          <p><span class=\"bold underline\">Visual/Spatial Intelligence:</span>  Capacities encompassed here include being able to mentally picture something, perceiving the relationship between objects in the world and recreating what you.ve seen.  Examples include an infant recognizing different faces or a toddler looking for a toy behind the chair.</p>
          <p><span class=\"bold underline\">Movement/Physical Intelligence:</span> This area is characterized by good body coordination and the ability to use your body to express yourself and reach goals.  It includes good control of large and fine motor skills and the ability to handle objects skillfully.  Some examples can be an infant learning to crawl or a toddler kicking a beach ball.</p>
          <p><span class=\"bold underline\">Emotional Intelligence:</span> This area focuses on our awareness of our emotions, how they impact our actions and effect those around us.  Our ability to recognize and  react to our feelings indicate how well we understand our emotions.  An example can be a baby crying as a reaction to overstimulation or a toddler feeling jealous of the brand new toy his or her sister just received.</p>",
                         :menu_order => 1, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "lerning_windows",
                         :label => "Lerning Windows", 
                         :content => "<h4>BabyFolio - Learning Windows</h4>
          <p>Development in each of the multiple intelligences follows a presribed path - which we describe as a series of Learning Windows. These  Learning Windows are important .sensitive. periods of development for a child. It is a period when the child seems to exhibit a proclivity to exercise a critical behavior or skill, during which the child is particularly sensitive to certain types of <a target=\"_blank\" href=\"http://www.google.com/url?q=http%3A%2F%2Fen.wikipedia.org%2Fwiki%2FStimulus_(physiology)&amp;sa=D&amp;sntz=1&amp;usg=AFQjCNEPImIH1QeCYDkQZtWAiQP5YPIYxg\">stimuli</a> or interactions. According to Maria Montessori, who was instrumental in popularizing the concept, during a sensitive period it is very easy for children to acquire certain abilities, in areas such as <a target=\"_blank\" href=\"http://www.google.com/url?q=http%3A%2F%2Fen.wikipedia.org%2Fwiki%2FLanguage&amp;sa=D&amp;sntz=1&amp;usg=AFQjCNHj-NpcUbWEpJIyk0iLh5f5TghGCQ\">language</a>, logic, social and emotional development. She attributed these behaviors to the development of specific areas of the <a target=\"_blank\" href=\"http://www.google.com/url?q=http%3A%2F%2Fen.wikipedia.org%2Fwiki%2FHuman_brain&amp;sa=D&amp;sntz=1&amp;usg=AFQjCNH1q4mCbKARFiOzuB57zqx1AE6TeQ\">human brain</a>.</p>
          <p>The extreme form of the idea is that failure to learn a particular skill during a given period leaves the cortical areas normally allocated for that function to fall into disuse. These unused brain areas will eventually adapt to perform a different function and twill no longer be available to perform the intended function. This more strict version of the theory is also referred to as a .critical period., as opposed to a .sensitive period.. For example, there is a period when a baby is extremely sensitive to vocal sounds and to movements of the vocal apparatus. Out of all the sounds in an infant's environment, the infant will be attracted to that of human sounds. Deprivation of language stimuli during this period can lead to severe language defects. Without stimulation, the <a target=\"_blank\" href=\"http://www.google.com/url?q=http%3A%2F%2Fen.wikipedia.org%2Fwiki%2FChemical_synapse&amp;sa=D&amp;sntz=1&amp;usg=AFQjCNEk6y-1YiiWL_HzMzL33AsprdhLuw\">synapses</a> of <a target=\"_blank\" href=\"http://www.google.com/url?q=http%3A%2F%2Fen.wikipedia.org%2Fwiki%2FBroca%2527s_area&amp;sa=D&amp;sntz=1&amp;usg=AFQjCNH3yqZX9v41fJxbi_0o4wQO2Lf2Xg\">Broca's area</a> and related language-processing areas of the brain will literally waste away and not develop the strong connections and foundations necessary for critical aspects of language processing.</p>
          <p>Most researchers would probably agree that critical periods are not as common as the more extended and looser .sensitive. period. These periods are not as hard and fast as Montessori believed. Current research has shown that humans are resilient and can develop skills over broader timeframes and in diverse contexts. However, the research still supports that there are periods of time during development when an individual is more receptive to specific types of environmental stimuli, that makes the individual more predisposed to learning that skill.</p>
          <p>Naturally, there are times when growth occurs more rapidly than others  For example, children often experience a surge in language development at particular ages when a number of developments come together for them, such as realizing everything has a name or words that can help in getting one.s needs met.  We believe that it is important to pay close attention to when a child is exhibiting certain behaviors and if they seem to want to exercise a certain budding skill or competence, it is advantageous to support them in exercising that skill at that time. We have termed it .the right play at the right time.. And it is based on following the child.s cues of where they are and what behaviors they are interested in expressing.</p>
          <p>The idea is not to hurry through one development to move onto the next in a race to move your child along developmentally but rather to deepen and solidify the development they are primed for to create the strongest foundations possible in that area of development.</p>
          <p>BabyFolio helps support parents and caregivers in this by sensitizing them to what behaviors and skills are budding and then providing tips to create the right play at the right time. Such play will also establish the foundations for rich parent-child interactions.  BabyFolio is here to help build those rich parent-child interactions and relationships.</p>
          ",
                         :menu_order => 1, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "faqs",
                         :label => "FAQs", 
                         :content => "<h4>FAQs</h4>
          <p>1. What is your mission?</p>
          <p>We help babies thrive.</p>
          <p>Every day, every moment of their lives, our children are learning and developing. They are wired to learn and thrive in this world. BabyFolio makes this ongoing and subtle learning more visible so parents can see more and be more responsive-- so parents can partner with their children, learning about them as parents help them learn. Our goal is to enable parents to better understand their unique baby and provide more responsive and individualized support so that their baby gets the best possible start. We do this by promoting real engagement and wonderful play between parents and babies as they build strong and intimate relationships. BabyFolio instills confidence and peace of mind for parents because they know that they are doing the best they can for their baby. </p><br>

          <p>2. How does this happen?</p>
          <p>Our site is designed to help your child learn based on how he or she is developing, and not based on how everyone else is or .should. be growing.  We know each child is unique and respect that everyone develops differently.  So we customize our information and activities based on what you tell us your child is doing.</p><br>

          <p>3. What do I get for signing up?</p>
          <ul class=\"content-ul\">
            <li>Get targeted information about your child.s unique development based upon a profile we help you create.</li>
            <li>Have access to parenting tips and play activities tailored to strengthen your child.s most important developments.</li>
            <li>View detailed descriptions and examples of future behaviors your child will exhibit so you know when a learning opportunity is available.</li>
            <li>Privately share and discuss your child.s development with close family and friends that you invite to your child.s BabyFolio.</li>
          </ul><br>

          <p>4. Are there any fees or membership dues required to be a member?</p>
          <p>Nope, our awesome new product is currently free!</p><br>

          <p>5. Why do I need to upload a picture of my baby?  What do you do with my family.s personal information?</p>
          <p>BabyFolio will create a private (viewed only by you and people you invite) timeline of your baby.s unique development and just like a scrapbook, pictures can help make the timeline more meaningful and fun for you to view.  Please rest assured that we will keep your pictures and information private and confidential.  We will not share your content with advertisers, organizations or anyone else.</p><br>

          <p>6. Do I have to post to the timeline?  Can anyone see my baby.s timeline?</p>
          <p>You do not have to post to the timeline, but we encourage you to do so as it is a nice and fun way for you to track and write about behaviors your baby has exhibited and activities your baby has completed.  It is also a great way for you share your baby.s development with people you invite to your child.s BabyFolio.  Lastly the posts created in the timeline help you gain insight into who your unique baby is as you see patterns of behavior over time. Your baby.s timeline is absolutely private and can only be seen by you and the people you invite.</p>",
                         :menu_order => 1, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "our_team_experts",
                         :label => "Our Team of Experts", 
                         :content => "<h4>Our Team of Experts:</h4>
          <p><span class=\"bold\">Research and Development:</span><br>
             <span class=\"bold\">Dr. Tina Grotzer</span> is a Research Associate in the Cognitive Skills Group of Project Zero at the Harvard Graduate School of Education, Harvard University.  Dr. Grotzer is an educational advisor to projects in children.s television and national and international curriculum projects and to diverse organizations including the Harvard Smithsonian Center for Astrophysics and Disney/ABC.  A former teacher, she has designed and taught programs for ages 3-12 and has worked with diverse populations of children.  Subsequently, she worked with numerous school systems connecting developmental and learning research with practice by providing professional development to teachers and advice to parents on how to support their children.s growth.  Her early research focused on children.s social and moral development.  Her recent research considers topics in children.s cognitive development, such as the growth of system.s concepts, the .learnability. of intelligence, and how to help children grow to be effective thinkers.  She has edited and authored articles and books on the nature of intelligence, adolescent and adult and development and children.s learning in math and science.  She is currently collaborating with Drs. David Perkins and Howard Gardner on a chapter for the handbook on intelligence.
          </p>
          <p><span class=\"bold\">Preschool:</span><br>
             <span class=\"bold\">Dr. George Forman</span> is an author well known in education for his clear extension of developmental theory into early childhood education and practice.  His books include The Child.s Construction of Knowledge, Constructive Play, and The Hundred Languages of Children.  He has designed toys, games, jigsaw puzzles, and a gravity wall with moveable ramps for balls to roll down, found in children.s museums worldwide.  He has studied the educational value of play and play objects.  Dr. Forman has worked with educators in India, Sweden, Japan, Korea, Finland, Australia and particularly Northern Italy where he has studied new methods to use drawing and other media to help children make their ideas visible.  Dr. Forman also has a keen interest in the use of computers and video as learning tools for young children.  He is a retired professor at the University of Massachusetts in Amherst where he taught courses in child development and early education.  He is married and the father of one son, Jed.
          </p>
          <p>
            <span class=\"bold\">Infant and Toddler:</span><br>
            <span class=\"bold\">Dr. Kevin Nugent</span> is director of the Brazelton Center for Infants and Parents at the Children.s Hospital in Boston.  He is a developmental psychologist and has led the research studies on newborn behavior and early parent-infant studies with T. Berry Brazelton since 1978 at the Harvard Medical School.  He has been the director of Brazelton Scale training for the past 17 years.  Dr. Nugent is co-author with Dr. Brazelton of th Neonatal Behavioral Assessment Scale.  His research interests include the role of fathers in child development, family transitions to parenthood, the influence of parents and parent actions on family functioning and developmental outcome.  He conducts research in different cultural settings around the world and is the senior editor of the three volume series, The Cultural Context of Infancy.  Dr. Nugent is a professor of child development at the University of Massachusetts at Amherst.  He on the faculty of the Harvard Medical School and is a research associate at Children.s Hospital in Boston.
          </p>",
                         :menu_order => 1, 
                         :field_type => "wysiwyg"
                       })

  end

  def down
    page = Page.find_by_slug("about")
    CustomField.where(:page_id => page.id).delete_all
    page.delete;    
  end

end
