class CreatePrivacyPolicyPage < ActiveRecord::Migration
  def up
    page = Page.create({:title => "Privacy Policy", :slug => "privacy_policy"})
    
    CustomField.create({
                         :page_id => page.id, 
                         :slug => "title",
                         :label => "Title", 
                         :content => "Privacy Policy",
                         :menu_order => 1, 
                         :field_type => "wysiwyg"
                       })

    CustomField.create({
                         :page_id => page.id, 
                         :slug => "content",
                         :label => "Content", 
                         :content => "<h5>Introduction</h5>
  <p>In this Privacy Policy, we (BabyFolio) describe how we use personally identifiable information about you and your children that we collect through www.babyfol.io that display a direct link to this Privacy Policy.</p>

  <h5>About Babies</h5>
  <p>This site is not intended for children over the age of 5. We do not knowingly collect personally identifiable information via this site from visitors in this age group. We do, however, collect information about children and babies, ages 0-5, from their parents. We ask that our users not provide information about a baby or child without first getting the parents' consent. We encourage parents to talk to their children about their use of the Internet and the information they disclose to Web sites.</p>

  <h5>Types of Data Collected; Collection Methods; Combination of Data</h5>
  <p>You actively send information to us when you sign up with us as a member onwww.babyfol.io, participate in surveys or promotions, post opinions on our bulletin boards, respond to us or otherwise contact us. Depending on your choices, you may send us personally identifiable information such as your email address, name; password; baby.s birthday, name and gender. We also track information about how www.babyfol.io is used by you through cookies, Internet tags or web beacons, and navigational data collection (log files, server logs, clickstream).</p>

  <h5>Purposes of Data Collection</h5>
  <p>We collect information about you because we want to determine what you may like and find interesting and helpful, so we can provide you with targeted information and advertising (on www.babyfol.io in newsletters, via email and otherwise). In addition, we use data to create statistics and reports where personally identifiable information has been removed and aggregated (such that it is anonymous as regards any specific user) for various business purposes.</p>

  <h5>Disclosure of Data</h5>
  <p>We keep your personally identifiable information confidential and we generally do not disclose it. But, please note the following clarifications and exceptions:</p>
  <ul class=\"content-ul\">
    <li>Our employees and independent contractors have access to some of your personally identifiable information for the purpose of helping us run our business (and not for their own purposes). They access and use such data subject to our instructions, on a \"need to know\" basis and under confidentiality and security obligations.</li>
    <li>We may also share your personally identifiable information to respond to law enforcement requests, court orders or other legal process or if we believe that such disclosure is necessary to investigate, prevent or respond to illegal activities, fraud, physical threats to you or others or as otherwise required by any applicable law or regulation.</li>
  </ul>

  <h5>Security</h5>
  <p>We take reasonable steps to protect personally identifiable information from loss, misuse, and unauthorized access, disclosure, alteration, or destruction. But, you should keep in mind that no Internet transmission is ever completely secure or error-free. In particular, email sent to or from the www.babyfol.io may not be secure.</p>

  <h5>Access and Correction; Comments and Questions</h5>
  <p>Please keep your personally identifiable information, accurate, current, and complete by routinely updating your profile.  If you have any questions, comments or concerns regarding this Privacy Policy, please send us an email at tickets@baby1.uservoice.com.</p>",
                         :menu_order => 2, 
                         :field_type => "wysiwyg"
                       })

  end

  def down
    page = Page.find_by_slug("privacy_policy")
    CustomField.where(:page_id => page.id).delete_all
    page.delete;    
  end
end
