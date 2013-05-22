class WelcomeProgramMailer < ActionMailer::Base
  default :from => ENV['EMAIL_FROM'] || "test@babyfolio.qa.codephonic.com"
  
  def welcome_email user, child, max_seen
    @user = user
    @child = child
    @max_seen = max_seen
    
    @next_behaviour = Behaviour.get_next_behaviours_for_category(@max_seen.category, @max_seen.age_from, 1).first
    mail(:to => user.email, :subject => "Jumpstart BabyFolio: 5 Day Program")
  end

  def day_1_email user, child
    @user = user
    @child = child

    @behaviours = {}

    Behaviour::CATEGORIES_ORDER.each do |key|
      current_behaviour = @child.behaviours.max_for_category(key).first
      @behaviours[key] = Behaviour.get_next_behaviours_for_category(key, (current_behaviour ? current_behaviour.age_from : 0), 1).first
    end
    
    mail(:to => user.email, :subject => "Jumpstart BabyFolio: Day 1")
  end

  def day_2_email user, child
    @user = user
    @child = child
    
    mail(:to => user.email, :subject => "Jumpstart BabyFolio: Day 2")
  end

  def day_3_email user, child, behaviour
    @user = user
    @child = child
    @behaviour = behaviour
    
    mail(:to => user.email, :subject => "Jumpstart BabyFolio: Day 3")
  end

  def day_4_email user, child, behaviour
    @user = user
    @child = child
    @behaviour = behaviour
    @category = @behaviour.category
    @year = (@child.years_old > 4) ? 5 : @child.years_old
    
    next_behaviour_ids = (Behaviour.for_category(behaviour.category).where(["age_from >= ?", @behaviour.age_from]).map(&:id) - @child.seen_behaviours.map(&:behaviour_id))
    @next_behaviours = Behaviour.find(next_behaviour_ids, :order => "age_from asc, learning_window asc", :limit =>2)
    
    mail(:to => user.email, :subject => "Jumpstart BabyFolio: #{EMAIL_CATEGORIES[@category]}")
  end

  def day_5_email user
    @user = user
    
    mail(:to => user.email, :subject => "Jumpstart BabyFolio: Day 5")
  end

  def self.get_random_baby_image_src
    "/images/welcome_program/"+BABY_IMAGES[rand(BABY_IMAGES.size)]
  end

  BABY_IMAGES = ["baby_towel.jpg", "baby_playing_duck.jpg", "baby_playing_toy.jpg", "baby_playing_toy_1.jpg"]

  EMAIL_CATEGORIES = {
    "L" => "Language",
    "N" => "Logic and Number",
    "S" => "Social",
    "V" => "Visual and Spatial",
    "M" => "Physical and Movement",
    "E" => "Emotional"
  }

  EMAIL_CATEGORIES_FULL = {
    "L" => "Language Intelligence",
    "N" => "Logic and Number",
    "S" => "Social",
    "V" => "Visual and Spatial",
    "M" => "Physical and Movement",
    "E" => "Emotional"
  }

  EMAIL_FOOTER_TEXT = {
    "L" => "Remember, we're here to help - check out the neat information we have waiting for you on the next page.",
    "N" => "",
    "S" => "Let's help <babyname> build strong social skills!",
    "V" => "",
    "M" => "",
    "E" => "Let's begin supporting <babyname>.s emotional development!"
  }


  
  EMAIL_YEARS = ["First", "Second", "Third", "Fourth", "Fifth"]

  EMAIL_COL_NAMES = 
    { "L" => ["Receptive Language", "Expressive Language Opportunities", "Making Marks & Writing"],
      "N" => ["Attention & Memory", "Ordering Their World", "Reasoning & High Order Thinking"],
      "S" => ["Learning From Your Actions", "Social Obstacles", "Learning Sense of Self and Independence"],
      "V" => ["Mentally Processing Objects and Their Purposes", "Mapping Their World", "Keeping Object Images in Mind (Object Permanence)"],
      "M" => ["Gross Motor Developments", "Fine Motor Developments"],
      "E" => ["Emotional Development", "Self-Soothe and Coping Skills"] }
  
  EMAIL_TITLE = 
    { "L" => ["We'll begin with <his/her> Language Intelligence. The foundation is being set for <his/her> oral, written and all effective communication skills in these critical early years.",
              "We'll begin with <his/her> Language Intelligence. The second year is a time of significant communication and language development.",
              "We'll begin with <his/her> Language Intelligence. The third year is a time when children learn to communicate better and in more complex ways.",
              "We'll begin with <his/her> Language Intelligence. The fourth year is a time when children learn to communicate better and in more complex ways.",
              "We'll begin with <his/her> Language Intelligence. The fifth year is a time when children learn to communicate better and in more complex ways."],
      "N" => ["Let's discuss Logic and Number Intelligence. During the first year, infants are piecing together a logical mental picture of their world and the way it works.",
              "Let's discuss Logic and Number Intelligence. During the second year, infants are making discoveries and solvin problems.",
              "Let's discuss Logic and Number Intelligence. During the third year, infants are very curious about what cause and effect and problem-solving.",
              "Let's discuss Logic and Number Intelligence. During the fourth year, infants are very curious about what cause and effect and problem-solving.",
              "Let's discuss Logic and Number Intelligence. During the fifth year, infants are very curious about what cause and effect and problem-solving."],
      "S" => ["Let's focus on <babyname>'s Social development today. The first year is a time for learning to trust the world and people in it.",
              "Let's focus on <babyname>'s Social development today. The second year is a time for <babyname> to understand that <he/she> is a separate person from others and can make things happen.",
              "Let's focus on <babyname>'s Social development today. The third year is a time for <babyname> to assert <him/her> self as a separate person from you and other people.",
              "Let's focus on <babyname>'s Social development today. The fourth year is a time for <babyname> to start experimenting with \"false truths\" and planning pretend play with friends.",
              "Let's focus on <babyname>'s Social development today. The third year is a time for <babyname> to assert <him/her>self as a separate person from you and other people."],
      "V" => ["Let's discuss Visual/Spatial Intelligence.",
              "Let's discuss Visual/Spatial Intelligence.",
              "Let's discuss Visual/Spatial Intelligence.",
              "Let's discuss Visual/Spatial Intelligence.",
              "Let's discuss Visual/Spatial Intelligence."],
      "M" => ["We'll discuss <babyname>'s Movement development today. Dramatic physical developments take place during the first year of life.",
              "We'll discuss <babyname>'s Movement development today. The pace of the second year is by far much quicker than that of the first year.",
             "We'll discuss <babyname>'s Movement development today. Your child's physical developments over the course of this year are dramatic.",
             "We'll discuss <babyname>'s Movement development today. Your child's physical developments over the course of this year are dramatic.",
              "We'll discuss <babyname>'s Movement development today. Your child's physical developments over the course of this year are dramatic."],
      "E" => ["Today is all about <babyname>'s Emotional development.",
              "Today is all about <babyname>'s Emotional development.",
              "Today is all about <babyname>'s Emotional development.",
              "Today is all about <babyname>'s Emotional development.",
              "Today is all about <babyname>'s Emotional development."]
    }

  EMAIL_AMAZING_CHANGES =
    { "L" => ["Think about the language difference between newborn <babyname> and one year old <babyname> when <he/she> will be speaking first words and gesturing.",
              "Consider the communication difference between a gesturing 12 month old <babyname> and a full word-using 24 month old <babyname>.",
              "Consider the difference between the two word sentences of a 24 month old <babyname> and the grammatically complex conversations of a 3 yr old <babyname>.",
              "Consider the difference between the grammatically complex conversations of 36 month old <babyname> and usage of more and different words of a 4 yr old <babyname>.",
              "Consider the difference between the many words of 48 month old <babyname> and the advanced story telling of a 5 yr old <babyname>."],
      "N" => ["Consider the difference between reflex-driven newborn <babyname> and one year old <babyname> who can control <his/her> attention & memory and begin conceptual categorization.",
              "Consider the  difference between a 12 month old's tentative understandings and a 2 yr old who demonstrates a vast memory for the scripts of daily life and reasons through situations and problems.",
              "Consider the differences between a 24 month old operating in the here-and-now world of action and a 3 year old's vastly increased repertoire of symbols to represent ideas and images as they enter the world of imagination.",
              "Consider the differences between a 36 month old using symbols to represent ideas and images and a 4 year old's developing analytical skills.",
              "Consider the differences between an analytical 48 month old <babyname> and a 5 year old's developing analytical skills."],
      "S" => ["Consider the difference between reflex-driven newborn <babyname> and one year old <babyname> who can control <his/her> attention & memory and begin conceptual categorization.",
              "<babyname> will experience intense social development during the second year of life.",
              "The third year is a time of immense social growth and development for <babyname>.",
              "The fourth year is a time of tremendous social growth and  development for <babyname>."],
      "V" => ["During the first year, infants are beginning to map a sequential and spatial order to the world, and reflecting on their experiences and mental representations.",
              "During the second year, infants are beginning to build spatial maps of their world.",
              "During the third year, infants are expandng their symbolic thinking and mental representations of their world.",
              "During the fourth year, infants are expandng their prespectives of how the world looks.",
              "During the fifth year, infants are making great strides in their visual/spatial thinking."
             ],
      "M" => ["Consider the physical difference between an arm flailing newborn and a toddling 12 month old! By the end of their first year, infants are amazingly mobile with substantial gross motor control, and a love of moving",
              "Consider the physical difference between a 1 year old not quite toddling and a climbing, kicking and jumping 2 yr old.",
              "Consider the physical differences between a 24 month old's ability to manipulate objects and a 3 year old's ability to hold a crayon, copy crude circles, use scissors and unbutton large buttons.",
              "Consider the physical differences between a 36 month old's ability to hold a crayon and copy crude circles and a 4 year old's ability to hop  and skip.",
              "Consider the physical differences between a 48 month old's ability to skip and hop and a 5 year old's ability to anticipate and prepare for a moving object."],
      "E" => ["Emotional development in the first year important abilities are key to a range of other developments, including cognitive, language and social abilities.",
              "Your child will experience intense emotional growth and development during the second year of life.",
              "The third year is a time of immense emotional growth and development.",
              "The fourth year is a time of immense emotional growth and development.",
              "The fifth year is a time of immense emotional growth and development."]
    }       

  EMAIL_NEW_BEHAVIOURS = 
    { "L" => ["During the <first> year, <babyname> will be:
                <ul><li>Having thoughts and needs and learning how to share these with others.
                </li><li>Using language and gesturing to make things happen in their world.
              </li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "During the second year, <babyname> will be:
<ul><li>Building a significant vocabulary and realizing all things have names.
</li><li>Learning some rules of grammar and even beginning to express <him/her>self using two word sentences and phrases.
</li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "During the third year, <babyname> will be:
                <ul><li>Learning new words from the context of stories and conversations.
                </li><li>Using language to express feelings and wants, to try to resolve conflict and negotiate with someone
              </li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "During the fourth year, <babyname> will be:
<ul><li>Learning polite language.
</li><li>Making if-then statements.
</li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "During the fourth year, <babyname> will be:
                <ul><li>Distinguishing between nouns and adjectives.
                </li><li>Developing advances storytelling skills.
              </li><li><babyname> is currently working on <LWtitle>.</li></ul>"],
      "N" => ["During the <first> year, <babyname> will be:
                <ul><li>Gaining control of their attention
                </li><li>Building their memory.
              </li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "During the second year, <babyname> will be:
<ul><li>Learning to categorize objects.
</li><li>Recognizing \"more\" and \"less.\"
</li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "During the third year, <babyname> will be:
<ul><li>Setting important foundations for their math skills.
</li><li>Using more complex problem-solving strategies, such as \"backtracking\".
</li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "During the fourth year, <babyname> will be:
<ul><li>Using clues to infer what happened.
</li><li>Reasoning about categories.
</li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "During the fourth year, <babyname> will be:
<ul><li>Telling the difference between tricks and magic.
</li><li>Using everyday activitiesy to think about time.
</li><li><babyname> is currently working on <LWtitle>.</li></ul>"],
      "S" => ["During the <first> year:
<ul><li>Infants' earliest basic and physical needs are focused mostly on feeding, physical comfort and security.
</li><li>Early social learning is shaped by how you respond to these needs. As you are more attentive and interactive, <babyname> will learn to respond back to you. E.g. You smile and <babyname> smiles back.
</li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "During the <seocnd> year:
                <ul><li>You and other important adults in your child's life remain very central to the world of your one year old as he develops a new sense of self.
                </li><li>Despite an increasing sense of independence, separation anxiety peaks during this period, typically at around 18 months of age.
                </li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "During the third year:
                <ul><li>Children begin to assert themselves, making known what they like and don't like.
                                 </li><li>They will also begin to protest and question rules.
                                                      </li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "During the fourth year:
<ul><li>Children begin to interact more with others as they plan out what they will play.
</li><li>They will also begin tothink about the intentions of others more.
</li><li><babyname> is currently working on <LWtitle>.</li></ul>"],
      "V" => ["During the <first> year, <babyname> will be:
<ul><li>Showing preferences for certain kinds of visual stimuli.
</li><li>Noticing patterns.
</li><li>Holding mental images of objects in <his/her> mind.
</li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "During the second year, <babyname> will be:
<ul><li>Viewing things from new vantage points.
</li><li>Thinking about new challenges, perspectives and frustrations.
</li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "During the third year, <babyname> will be:
<ul><li>Using symbols to represent objects.
</li><li>Moving from scribbles to drawings of people and objects.
</li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "During the fourth year, <babyname> will be:
<ul><li>Creating spatial enclosures with blocks
</li><li>Drawing hidden objects
</li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "During the fifth year, <babyname> will be:
<ul><li>Learning how moving something changes how it looks.
</li><li>Using visual scanning strategies
</li><li><babyname> is currently working on <LWtitle>.</li></ul>"],
      "M" => ["<MNewBehaviors>During the <first> year, <babyname> will be:
<ul><li>Amazingly mobile with substantial gross motor control, and a love of moving.
</li><li>Amazingly mobile with substantial gross motor control, and a love of moving.
</li><li>Manipulating objects with both hands, sometimes drawn to inspecting the smallest of pieces.
</li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "<MNewBehaviors>During the second year, <babyname> will be:
                <ul><li>Building <his/her> orchestra of physical competences across gross motor and fine motor abilities
                </li><li>New physical mobility and dexterity opens up a much bigger world to them for increased explorations, independence, and discoveries.
                                                                                               </li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "<MNewBehaviors>During the third year, <babyname> will be:
.Learning \"true\" running and how to strike a ball on the ground.
<ul><li>Walking up the stairs with help and balancing on one foot.
</li><li>Improving <his/her> throwing  and now learning to catch.
</li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "<MNewBehaviors>During the fourth year, <babyname> will be:
<ul><li>Skipping.
</li><li>Hopping
</li><li>Increasing <his/her> fine motor control.
</li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "<MNewBehaviors>During the fifth year, <babyname> will be:
<ul><li>Bouncing a ball.
</li><li>Getting Ready for A Moving Object
</li><li><babyname> is currently working on <LWtitle>.</li></ul>"],
      "E" => ["During the <first> year:
<ul><li>Infants are shaping emotional learning based on how their parents respond to their needs.
</li><li>Infants will be emotional signaling, where they turn to the parent and make an interesting sound and the parent gives a big smile. They smile back and parent makes another sound and so it continues. 
</li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "During the second year:
<ul><li>Separation anxiety will cause <babyname> to demand your attention more.
</li><li>You may begin to see your child experiencing moments of shame in certain instances.  You may see your child's head droop, their smile disappear, and they may possibly begin to cry. 
</li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "During the third year:
<ul><li>Separation anxiety will cause <babyname> to demand your attention more.
</li><li>You may begin to see your child experiencing moments of shame in certain instances.  You may see your child's head droop, their smile disappear, and they may possibly begin to cry. 
</li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "During the fourth year:
<ul><li>Delaying gratification.
</li><li>Experiencing guilty feelings.
</li><li><babyname> is currently working on <LWtitle>.</li></ul>",
              "During the fifth year:
<ul><li>Laughing at things that don't sound or look like they usually do
</li><li>Developing new fears.
</li><li><babyname> is currently working on <LWtitle>.</li></ul>"]

    }

  EMAIL_LEARNING_OPPORTUNITIES = 
    { "L" => ["Learning Opportunities: Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Learning Opportunities: Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Learning Opportunities: Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Learning Opportunities: Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Learning Opportunities: Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods."],
      "N" => ["Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods."],
      "S" => ["Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods."
             ],
      "V" => ["Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods."],
      "M" => ["Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods."],
      "E" => ["Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods.",
              "Each new behavior or \"learning window\" reveals an opportunity in which your child is eager to exercise that skill and is predisposed to learning it (see learning windows, sensitive period). See below for the types of things you can do take advantage of these sensitive periods."]

    }

  
  EMAIL_YOUR_ROLE_HEADERS = [
                             { "L" => ["<ul><li>Newborns respond to voices and sound around them and recognize the voices of their mothers and fathers.
              </li><li>One of the first words that babies recognize is their own name. This a big deal for their language development, so use your child's name often!</li></ul>",
              "<ul><li>As <babyname> begins to realize that every object has a name, <he/she> will begin to learn many new words and quickly map labels to objects as <he/she> hears things being labeled and referred to with words.
                                                                                                  </li><li>This new knowledge will help <babyname> to make fewer over-generalizations with names.  For example, <he/she> is learning that not all vehicles with wheels are cars.</li></ul>",
              "<ul><li>As language comprehension grows, children begin asking ""why?"" questions and discover the power of such questions for finding out things about their world.
                                                                                                                                         </li><li>Later in the 3rd year, Children tend to experience a second dramatic vocabulary explosion.  They have learned that words represent things and know enough words to help them figure out new words by context very quickly.</li></ul>",
              "<ul><li>Four year olds begin to use the rule that the first noun in the sentence is always the actor, and therefore think that the car is the actor in the sentence \"The car was hit by the truck\". This mistake is called a \"growth error\" because it shows that children are beginning to use language rules that they don't use at early ages.
</li><li>At this age children are beginning to understand why it is important to use politeness.</li></ul>",
              "<ul><li>Understanding the difference between parts of speech helps children to learn new words in context by distinguishing between a describing word, an actionword  and a noun.
</li><li>Learning how to distinguish an adjective from a noun is useful because it helps children to learn about categories of things and different types within a category.</li></ul>"],
                               "N" => ["<ul><li>Over the first 3 months, babies become increasingly attentive and alert and can attend to the world in an organized way. They demonstrate selective focusing of their attention.
              </li><li>Memory for past events increases rapidly over the course of the first year. Young infants do not remember events; they are only able to recognize that they have seen something before.</li></ul>",
              "<ul><li>Based on their increasing experiences and improved memory, young children can make predictions of weight based on the size of an object.
</li><li>They can recognize and compare different qualities and quantities of objects.</li></ul>",
              "<ul><li>At this age children begin to question the cause of events and reason for happenings. For example, children might ask why a favorite toy isn.t working or why they can.t play outside.
</li><li>As they get older and better understand others, children also begin to ask about things such as their motivations and emotional reactions, asking for example, why someone is crying.</li></ul>",
              "<ul><li>Children begin to learn that every event that happens has a cause.
</li><li>Looking for clues to explain that cause indicates a development in children's logical thinking and a greater ability to understand their world.</li></ul>",
              "<ul><li>Children begin to see that the order of counting can change without effecting the total number of items.
</li><li>This shows that children are developing more sophisticated logic and number concepts.</li></ul>"],
                               "S" => ["<ul><li>Infants learn to show different facial expressions by watching their parents or primary caregivers.</li></ul>",
              "<ul><li><babyname> may make a game of separation and reunion, similar to playing \"peek-a-boo\" in infancy.  In this game you may find <him/her> running off again and again, but squealing with delight as you scoop them up.
              </li><li>You may also see <babyname> \"checking in\" with you by making eye contact or sharing a toy with you.</li></ul>",
              "<ul><li>As they learn more about their social world, children begin to incorporate familiar scenes into their play.
</li><li>With increased verbal skills and understanding of the world, children may also begin to imitate their parents and caregivers.</li></ul>",
              "<ul><li>Creating a plan for their pretend play with others shows that children at this age are developing the ability to plan, as well as discuss and negotiate the plan with others.
</li><li>Their play is also moving beyond the familiar scripts and roles of their everyday life and becoming more flexible, where children are able to tell a ""story"" based more in fantasy and what they imagine a character to do.</li></ul>"],
                               "V" => ["<ul><li>Infants will be more interested in certain colors and patterns.
             </li><li>They will show a preference for complexity; curved lines rather than straight ones; symmetrical over asymmetrical; and irregular over regular.</li></ul>",
              "<ul><li>Infants will be noticing shapes when looking at objects.
</li><li>Infants will also be more interested in objects with new and different patterns than solid-colored objects.</li></ul>",
              "<ul><li>Before they make representative drawings, children begin to experiment with drawing designs. Some common designs children at this age draw are zigzags, curved lines, loops and dense parallel lines.
</li><li>These drawn designs are the precursors for eventual letter writing.  Your child may begin naming her scribbles or telling stories about them.</li></ul>",
              "<ul><li>X-ray drawings are very common in children, who recognize that they inaccurately show what would normally be hidden.
</li><li>Children will sometimes create an explanation for their transparent drawings.</li></ul>",
              "<ul><li>Preschoolers are beginning to develop and use strategies for finding objects by systematically scanning in an orderly way.
</li><li>This ability suggests that preschoolers are able to selectively attend to some features and not others.</li></ul>"],
                               "M" => ["<ul><li>From his or her first wiggles and stretches, your baby is developing upper body strength.pushing up on their arms, rolling over and pulling to sitting by holding onto someone's hands.
</li><li>Early attempts to stand with an adult holding under their arms as they push and extend their legs develops the strength that allows them to sit up, lunge forward and crawl.</li></ul>",
              "<ul><li>Although walking has a broad range of onset from 9 months to 17 months, it marks a critical milestone-- the emergence from infancy to \"toddlerdom\". Walking progresses through a number of phases: First, there are short rigid flat-footed steps with almost no ankle movement, and then they evolve into more mature forms where the gait narrows and a heel strike is usually present. Soon enough, walking will turn into running!
</li><li>Climbing also begins to fascinate your child; Stairs, couches, coffee tables, stools and anything else that your child can climb will tempt him.
              </li><li>Movement is central to your active toddler's sense of well-being.  If your toddler remains indoors for too long he may get irritable and restless or even have a temper tantrum.</li></ul>",
              "<ul><li>Children's running progresses to a larger stride, longer and increased arm swing and increased speed.
</li><li>Throwing and catching skills evolve as well. Early catching attempts often involve trapping the ball into the chest with the arms held straight out infront of the body, palms up. 
</li><li>Children begin to throw a ball while standing, with a timely release as hand passes ear, instead of the more awkward hurling of objects. Now there is also much more intention to hit a target.</li></ul>",
              "<ul><li>Skipping is a rather complex movement which requires being able to coordinate two actions, the step and the hop.
</li><li>Skipping also requires a good amount of upper body strength. Skipping is part of many children's activities. 
</li><li>Being able to hop on one foot indicates an increase in children's strength, balance and coordination.</li></ul>",
              "<ul><li>At this age children are able to bounce and catch a ball with some control using both hands.
</li><li>This is an improvement over earlier attempts to drop and slap a ball wildly, with little control.
</li><li>This new ability is the result of greater hand-eye control and gross motor coordination.</li></ul>"],
                               "E" => ["<ul><li>Emotional signaling helps infants learn to tame overwhelming emotional patterns in the first year of life.
</li><li>Infants learn to use these emotional signals to communicate, negotiate, and govern emotional states, as well as to build other cognitive, language and social abilities.</li></ul>",
              "<ul><li>As your child learns about his own needs and intentions, he is also learning to express those needs and act on his intentions.
</li><li>Learning about the self, about rules and about how to express oneself does not come without challenges. This can be frustrating and sometimes leads to emotional meltdowns and tantrums.</li></ul>",
              "<ul><li>As your child makes great strides in understanding the world around him, his imagination may be working overtime and he may suddenly seem more dependent or clingy or even have nightmares.
</li><li>All young children sometimes are fearful.  You cannot eliminate your young child's fears but you can help them understand and learn how to deal with their fear.</li></ul>",
              "<ul><li>Delaying gratification shows a big development in self-control
</li><li>A preschooler's increasing ability to delay gratification is supported by growth in his/her logical thinking and emotional understandings</li></ul>",
              "<ul><li>Children's humor develops along with the growth in their language, social and cognitive skills at this time.
</li><li>Their increased experience in the world allows them to form expectations about how things are suppose to look and act and when those expectations are violated and they are surprised, they find it to be funny.</li></ul>"]
                             },
   { "L" => ["<ul><li>Throughout the first year, infants experiment with making sounds and communicating.
              </li><li>Research shows that teaching hand gestures helps give babies a way to communicate before speaking words and oral sentences, and paves the way for using other symbol systems to communicate- such as verbal or written language.</li></ul>",
              "<ul><li>Throughout the second year, infants will use a lot of object words, such as ""cat"" or ""dog,"" and will have a preference for certain verbs, such as ""go"" or ""zoom."" Infants will also be able to express feelings with words.
                                                                                                                                                 </li><li>Your child will be more effective in making <his/her> wants known to you as <he/she> adds the use of gestures to <his/her> words. Gestures enhance oral vocabulary growth.</li></ul>",
              "<ul><li>During the third year, children put to use their learning about turn-taking and when and how to address others.
              </li><li>As children begin having more conversations with others, they also begin to recognize if a message is understood and to repeat it and clarify if necessary.</li></ul>",
              "<ul><li>During the fourth year, children put to use more if-then statements, demonstrating their understanding of cause and effect.
              </li><li>Children begin to use the word, ""please"" more often as they learn polite language.</li></ul>",
              "<ul><li>With developments in their language skills and their increasing knowledge of stories and storybooks, children are learning about the structures of stories and storytelling.
              </li><li>Understanding the structure of stories, such that there is a beginning, middle and end, and that there is often a problem and resolution, helps children in telling stories.</li></ul>"],
      "N" => ["<ul><li>Throughout the first year, infants gain knowledge through their senses and begin to store, sort and use it to explore the world.
                                                                                                 </li><li>By three months old, they are drawn to events that are novel and become bored with familiarity . another example of nature's internal drive to learn and explore.</li></ul>",
              "<ul><li>Early in the second year, around 15-17 months, children begin to make comparisons between groups of things, recognizing which has more or less.
</li><li>At around 18 months, children are able to make comparisons between the qualities of objects, such as size, shape, color and function, putting things together in like groups.</li></ul>",
              "<ul><li>They learn about one-to-one correspondence, where they can match one thing to another.
</li><li>Just before their third birthday, most children learn to tell .how many. by counting a set of objects and knowing that the last number tells the quantity of what they have.</li></ul>",
              "<ul><li>Reasoning about the different ways an object can be labeled and grouped suggests that children are able to think in a more complex way about their world and the things in it.
</li><li>Thinking about basic kinds and general categories requires children to understand that a single object can be called by different names and that objects can belong to the same general category even when they do not look alike or have the same parts.</li></ul>",
              "<ul><li>Around this time children are beginning to understand concepts about time, such as morning, afternoon, nighttime.
</li><li>Children are also beginning to think about duration of time separating events throughout the day.</li></ul>"],
      "S" => ["<ul><li>Have you noticed how a young infant, when meeting a stranger, may cling to mom and or look away? As infants develop, they may still be wary or strangers but will learn how to respond without hiding in mom's shoulder.</li></ul>",
              "<ul><li><babyname> will also look to your reactions to strangers and new places and events as a gauge for their own reaction.
</li><li>Although your child may not need as much close physical proximity to you as they did in infancy, these psychological contacts from a distance are very important for reassuring your child.</li></ul>",
              "<ul><li><babyname> is slowly beginning to understand which of his ideas are real and which are pretend.
</li><li>Fears of such things as strange places, loud noises, Halloween masks or specific animals may develop.</li></ul>",
              "<ul><li>The ability to make someone think something that isn't true indicates that children are learning more about beliefs and how the minds of others work.
</li><li>This shows growth in their social development and logical thinking.</li></ul>"],
      "V" => ["<ul><li>In the second half of the first year, babies are better able to perceive their environment separate from themselves .
</li><li>Infants will organize and integrate the world into visual spatial and sequential order and categories.</li></ul>",
              "<ul><li>Increasing ability to form mental representations supports your child's language development as well as pretend play.
</li><li>At first your child will pretend at things they do, such as eating or sleeping.  Then you will notice your child extending these activities to others as they pretend to feed you, pretend to bathe their baby doll or put their doll to bed.</li></ul>",
              "<ul><li>As your child increasingly makes representative drawings you will also notice that construction toys, such as blocks and snap-together toys, will also become a rich medium for imaginative construction and you may begin to see your child building a .house. or a .train..
</li><li>Your child may begin organizing blocks or other objects into meaningful patterns and create roads, enclosures or creative settings for imaginary dramas.</li></ul>",
              "<ul><li>In order to see things from a different point of view, a child has to be able to 'override"" the immediate experience and mentally change what they are seeing.
</li><li>Being able to imagine different points of view helps us to visualize a path or consider what we see if we look in different directions.</li></ul>",
              "<ul><li>Children are able to see the similarity between model objects and the real world objects they represent.
</li><li>Children are able to use models such as pictures and maps for spatial information.</li></ul>"],
      "M" => ["<ul><li>By the end of the first year, infants typically can pick up small objects, manipulate them in their hands, and release them purposefully.
</li><li>Around 8 months old, infants start to use their opposable thumb to grasp- using all fingers as a unit against the thumb.  
</li><li>Toward the end of this year, this skill may begin to evolve into what is called a .neat. pincer grip. or the pressing of the thumb against individual fingers.
</li><li>By the end of the first year, watch how your infant bangs two blocks together. This takes eye-hand coordination and fine motor skill.</li></ul>",
              "<ul><li>After their first birthday, children can move from using all fingers as a unit against the thumb and begin to use what is called a .neat. pincer grip-- pressing their thumb against individual fingers.
</li><li>Coordinated releasing of objects doesn.t tend to occur until they begin hurling objects around 18 months.  
</li><li>Because it involves so many different body parts, the skill of throwing takes a long time to mature. Even at 2 and 3 years old, children use mostly forearm extension but little footwork or rotation of their bodies.
</li><li>Eye-hand coordination is improving so that 1 year olds can begin to stack and balance objects on each other.</li></ul>",
              "<ul><li>Developing skills will support more complex exploration of many materials and will support your child's increased independence with self-help behaviors such as eating and dressing.
</li><li>By the end of the year they can manage to undress themselves except for difficult buttons and fastenings and they can hang things up.
</li><li>Most notable is the increased control over the thumb. Children begin to master tasks such as cutting with scissors which requires the coordination of and incredible number of components. 
</li><li>With their increased physical control they may be engaging in such social and personal milestones as toilet training, brushing their teeth, moving into a .big kid. bed, and dressing and washing themselves.</li></ul>",
              "<ul><li>Children need to develop hand and finger skills in order to do such things as tie shoes, fasten buttons, write with a pencil and handle small objects like coins.
</li><li>Around now, children develop the pencil grip which is important because it allows them to have better control over their writing and drawing tools and in turn control the marks they make.
</li><li>A mature grip helps children to plan and control the trajectory of their writing tool. 
</li><li>This development is important for the development of their drawing skills and for the development of writing once they begin formal schooling.</li></ul>",
              "<ul><li>Getting ready for a moving object requires tracking a moving object and coordinating one's movements.
</li><li>Children's ability to successfully catch or hit a moving object requires hand-eye coordination and greater gross motor control.</li></ul>"],
      "E" => ["<ul><li>By twelve months old, infants begin to rely less on parents for comfort and soothing as they develop emotional skills that allow them to learn to self-soothe and cope with upset.
</li><li>By observing their parents. emotions and reactions, they learn how to react to certain situations.</li></ul>",
              "<ul><li>Even though they often risk parental disapproval by asserting their will, your toddler is seeking and needs your approval. allow them to learn to self-soothe and cope with upset.
</li><li>You may begin to see your child experiencing moments of shame in certain instances.  You may see your child's head droop, their smile disappear, and they may possibly begin to cry. This is a part of developing the ability to self-regulate behaviors.</li></ul>",
              "<ul><li>With greater communication abilities comes the ability to better control oneself and cope with one's emotions. Rather than simply acting on their angry or frustrated feelings, children will begin to talk about them. This usually means fewer tantrums and meltdowns by the end of this year.
</li><li>At this age, children will also begin to develop strategies to deal with upset, such as using distraction and turning to something else.</li></ul>",
              "<ul><li>Feeling guilt signals growth in children's emotional, social and cognitive development.
</li><li>Feeling guilt also suggests the development of a sense of conscience and an understanding of social values and standards for behavior.</li></ul>",
              "<ul><li>The new fears that children develop at this age reflect their increased experiences in the world and their increased independence from parents.
</li><li>Knowing more about the world and the possible dangers of it contributes to new fears, as does children's growing imagination.</li></ul>"]
   },
   { "L" => ["<ul><li>Later in the first year when babies can grasp a marker and scribble, their physical and mental gestures become visible and are shown more often.
              </li><li>Help lay the solid foundations for future symbol use by encouraging your baby's scribble</li></ul>",
              "<ul><li>Scribbles prepare your baby's brain to record sounds of speech and music, quantities and relationships and ideas- things we cannot touch and we cannot see.
</li><li>You can help lay the solid foundations for future symbol use by encouraging your baby's scribbles.</li></ul>",
              "<ul><li>Between 2 and 3 years, your child will take a giant step from when they begin to realize that their lines and squiggles can represent things. They will begin to draw circles and ellipses that are cleared of the whorls and lines used to fill their scribble pictures.
</li><li>Most children interpret these circles as .things.. Encourage them to describe what they have represented.</li></ul>"],
      "N" => ["<ul><li>Newborns begin to notice behavioral patterns in their world, particularly the responsive patterns of their caregivers. They learn that if they cry, someone will respond and try to meet their needs.
</li><li>By twelve months old, infants learn to string two to three steps to solve a problem.</li></ul>",
              "<ul><li>The understanding of cause and effect continues to develop and supports social development as your child develops a better understanding of others.
</li><li>Although it will be quite some time (as much as a year or two) before they are able to share well with others, toddlers are beginning to understand how their behavior causes others to feel.</li></ul>",
              "<ul><li>Other cognitive developments at this age allow children to use more complex problem solving strategies, such as backtracking.
</li><li>Although children still think in very concrete terms and won.t be able to think abstractly for some time to come, they are learning to remember what was tried in the past, what worked and didn.t work and to try a different approach when one way doesn.t work.</li></ul>",
              "<ul><li>Making inferences requires children to think about and remember how things are related.
</li><li>Being able to compare objects that are not present means that children are able to create and hold mental representations of objects in their memories.</li></ul>",
              "<ul><li>From their experiences with the physical world, children can begin to distinguish between possible and impossible events.
</li><li>When something seems to be impossible, children will seek to understand how it can be so, which suggests that they can tell the difference between magic and a trick.</li></ul>"],
      "S" => ["<ul><li>In the second part of the year, infants grow more independent and eager to explore on their own.</li></ul>",
              "<ul><li>Your child relies on you to be an emotional and social 'safe base. from which to explore the world.
</li><li>Allowing your toddler to move away and return to you freely helps them learn strategies for self-regulation.</li></ul>",
              "<ul><li>It is by testing limits and saying .no. that children often strive to create a 'self-identity..
</li><li>This also means that children at this age want to .be the boss. and will often insist on doing things themselves.</li></ul>",
              "<ul><li>Thinking about the intentions of others shows growth in children's logical thinking and social development.
</li><li>Children are learning more about the thoughts of others and are beginning to see things from the point of view of others, which helps them to think about intentions and whether or not someone did something on purpose.</li></ul>"],
      "V" => ["<ul><li>By twelve months, infants can hold a mental image of the toy that is out of sight and realize that the toy exists even though it cannot be seen. This is known as object permanence.
</li><li>They can figure out a way or ways to retrieve the toy; and perhaps to recall ways that s/he found a hidden object in the past and to repeat that strategy now.</li></ul>",
              "<ul><li>By the end of the second year you may see <babyname> pretending that <his/her> dolls/toys can feed themselves.
</li><li>Through this creative symbolism your child can find safe ways to express a variety of feelings, represent or .think. about their experiences and try out behaviors they see others exhibit.</li></ul>",
              "<ul><li>Children's symbolic thinking also develops during this period to allow children to use one thing to stand for another. They also know that pictures stand for people and objects, and that the pictures are not the objects themselves.
</li><li>This increases the creativity and imaginative aspects of their play, and allows them to create more elaborate pretend scripts when playing.</li></ul>",
              "<ul><li>Children begin to create an enclosed structure with blocks , which shows an increase in children's ability to plan and new developments in their spatial thinking.
</li><li>Children can now think about empty space and plan how to use it.</li></ul>",
              "<ul><li>The ability to recognize how moving an object changes the way it appears relates to children's understanding of how things look from different perspectives.
</li><li>They can understand that moving an object closer will make it appear bigger and easier to see.</li></ul>"],
      "M" => [],
      "E" => []
    }
]

end
