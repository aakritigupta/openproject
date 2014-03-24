#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2014 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

require 'spec_helper'

describe News, "authorization" do
  let(:created_news) { FactoryGirl.create(:news,
                                          :project => project,
                                          :author => user) }
  let(:project) { FactoryGirl.create(:project) }
  let(:user) { FactoryGirl.create(:user) }
  let(:role) { FactoryGirl.build(:role, :permissions => [ ]) }
  let(:member) { FactoryGirl.build(:member, :project => project,
                                            :roles => [role],
                                            :principal => user) }
  describe :visible do
    it "should be visible if user has the view_news permission in the project" do
      role.permissions = [:view_news]
      member.save!

      expect(News.visible(user)).to match_array([created_news])
    end

    it "should not be visible if user lacks the view_news permission in the project" do
      created_news

      expect(News.visible(user)).to match_array([])
    end
  end

  describe :visible? do
    it "should be true if user has the view_news permission in the project" do
      role.permissions = [:view_news]
      member.save!

      expect(created_news.visible?(user)).to be_true
    end

    it "should be false if user lacks the view_news permission in the project" do
      expect(created_news.visible?(user)).to be_false
    end

  end
end