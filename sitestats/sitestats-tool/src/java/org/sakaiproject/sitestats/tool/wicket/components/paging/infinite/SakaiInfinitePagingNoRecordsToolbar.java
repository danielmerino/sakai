/**
 * Copyright (c) 2006-2018 The Apereo Foundation
 *
 * Licensed under the Educational Community License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *             http://opensource.org/licenses/ecl2
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.sakaiproject.sitestats.tool.wicket.components.paging.infinite;

import org.apache.wicket.AttributeModifier;
import org.apache.wicket.markup.html.WebMarkupContainer;
import org.apache.wicket.markup.html.basic.Label;
import org.apache.wicket.model.IModel;
import org.apache.wicket.model.Model;
import org.apache.wicket.model.ResourceModel;

/**
 * Toolbar to display when there are no records to show in the table
 * @author plukasew
 */
public class SakaiInfinitePagingNoRecordsToolbar extends InfinitePagingDataTableToolbar
{
	private static final long serialVersionUID = 1L;

	public SakaiInfinitePagingNoRecordsToolbar(final InfinitePagingDataTable<?, ?> table)
	{
		super(null, table);

		WebMarkupContainer td = new WebMarkupContainer("td");
		add(td);

		IModel<String> colspanModel = Model.of(String.valueOf(table.getColumns().size()));
		td.add(AttributeModifier.replace("colspan", colspanModel));

		td.add(new Label("msg", new ResourceModel("no_data")));
	}

	@Override
	public boolean isVisible()
	{
		return getTable().getRowCount() < 1;
	}
}
