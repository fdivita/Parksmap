package com.openshift.evg.roadshow.parks;

import static org.junit.Assert.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
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

import com.openshift.evg.roadshow.parks.rest.BackendController;


@RunWith(SpringRunner.class)
@WebMvcTest(BackendController.class)
public class NationalParksTest{

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    BackendController controller;

    @Before
    public void setUp() throws Exception {

    }

    @Test
    //Test BackendsController get to localhost:8080/
    public void test1() throws Exception {
        RequestBuilder requestBuilder = MockMvcRequestBuilders.get(
                "/ws/healthz/");
        MvcResult result = mockMvc.perform(requestBuilder).andExpect(status().isOk()).andReturn();
        System.out.println("RESPONSE"+result.getResponse());
    }



    @Test
    //Test BackendsController get to /ws/data/load
    public void test2() throws Exception {
        RequestBuilder requestBuilder = MockMvcRequestBuilders.get(
                "/ws/data/load");
        MvcResult result = mockMvc.perform(requestBuilder).andExpect(status().isOk()).andReturn();
        System.out.println("RESPONSE"+result.getResponse());
    }

}
