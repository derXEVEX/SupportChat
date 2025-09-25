# app/helpers/activities_helper.rb
module ActivitiesHelper
  def render_activity_description(activity)
    case activity.item_type
    when "SupportRequest"
      support_request_activity_description(activity)
    when "Message"
      message_activity_description(activity)
    when "User"
      user_activity_description(activity)
    else
      "Unbekannte Aktivität"
    end
  end

  private

  private

  def support_request_activity_description(activity)
    case activity.event
    when "create"
      request = SupportRequest.find_by(id: activity.item_id)
      if request
        "Support-Anfrage \"#{request.title}\" erstellt"
      else
        "Support-Anfrage erstellt (gelöscht)"
      end
    when "update"
      request = SupportRequest.find_by(id: activity.item_id)
      if request
        changes = YAML.load(activity.object_changes) rescue {}
        if changes["status"]
          "Status der Support-Anfrage \"#{request.title}\" geändert von \"#{changes["status"][0]}\" zu \"#{changes["status"][1]}\""
        else
          "Support-Anfrage \"#{request.title}\" aktualisiert"
        end
      else
        "Support-Anfrage aktualisiert (gelöscht)"
      end
    when "destroy"
      "Support-Anfrage gelöscht"
    else
      "Unbekannte Aktivität mit Support-Anfrage"
    end
  end

  def message_activity_description(activity)
    case activity.event
    when "create"
      message = Message.find_by(id: activity.item_id)
      if message && message.support_request
        "Nachricht zur Support-Anfrage \"#{message.support_request.title}\" hinzugefügt"
      else
        "Nachricht hinzugefügt (Support-Anfrage gelöscht)"
      end
    when "update"
      message = Message.find_by(id: activity.item_id)
      if message && message.support_request
        "Nachricht in Support-Anfrage \"#{message.support_request.title}\" bearbeitet"
      else
        "Nachricht bearbeitet (Support-Anfrage gelöscht)"
      end
    when "destroy"
      "Nachricht gelöscht"
    else
      "Unbekannte Aktivität mit Nachricht"
    end
  end

  def user_activity_description(activity)
    case activity.event
    when "create"
      user = User.find_by(id: activity.item_id)
      if user
        "Benutzer #{user.name} (#{user.email}) wurde erstellt"
      else
        "Benutzer wurde erstellt (gelöscht)"
      end
    when "update"
      user = User.find_by(id: activity.item_id)
      if user
        changes = YAML.load(activity.object_changes) rescue {}
        if changes["role"]
          "Rolle des Benutzers #{user.name} wurde von \"#{changes["role"][0]}\" zu \"#{changes["role"][1]}\" geändert"
        elsif changes["email"]
          "E-Mail-Adresse des Benutzers #{user.name} wurde geändert"
        elsif changes["name"]
          "Name des Benutzers wurde geändert von \"#{changes["name"][0]}\" zu \"#{changes["name"][1]}\""
        else
          "Benutzer #{user.name} wurde aktualisiert"
        end
      else
        "Benutzer wurde aktualisiert (gelöscht)"
      end
    when "destroy"
      object = YAML.load(activity.object) rescue nil
      if object && object["name"]
        "Benutzer #{object["name"]} (#{object["email"]}) wurde gelöscht"
      else
        "Benutzer wurde gelöscht"
      end
    else
      "Unbekannte Aktivität mit Benutzer"
    end
  end
end
