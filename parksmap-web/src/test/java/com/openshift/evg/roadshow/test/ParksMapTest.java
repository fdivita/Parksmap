package com.openshift.evg.roadshow.test;

import static org.junit.Assert.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.runner.RunWith;
import org.springframework.test.context.junit4.SpringRunner;

import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

import org.junit.Before;
import org.junit.Test;

import com.openshift.evg.roadshow.rest.*;
import com.openshift.evg.roadshow.rest.gateway.model.*;


@RunWith(SpringRunner.class)
@WebMvcTest(BackendsController.class)
public class ParksMapTest{

	@Autowired
	private MockMvc mockMvc;
	
	@Autowired
	BackendsController controller;
	
	@Before
	public void setUp() throws Exception {
		
	}

	@Test
	//Test BackendsController get to localhost:8080/
	public void test1() throws Exception {
		RequestBuilder requestBuilder = MockMvcRequestBuilders.get(
				"/");
		MvcResult result = mockMvc.perform(requestBuilder).andExpect(status().isOk()).andReturn();
		System.out.println("RESPONSE"+result.getResponse());
	}
	
	
	@Test
	//Test Coordinates
	public void test2() throws Exception {
		
		Coordinates coordinates = new Coordinates("45","45");
		assertEquals("45", coordinates.getLongitude());
	}
	
	
	@Test
	//Test BackendsController get to localhost:8080/ws/backends/list
	public void test3() throws Exception {
		RequestBuilder requestBuilder = MockMvcRequestBuilders.get(
				"/ws/backends/list");
		MvcResult result = mockMvc.perform(requestBuilder).andExpect(status().isOk()).andReturn();
		System.out.println("RESPONSE"+result.getResponse());
	}

}
