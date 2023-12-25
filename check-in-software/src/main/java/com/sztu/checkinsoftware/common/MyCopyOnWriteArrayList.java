package com.sztu.checkinsoftware.common;

import org.springframework.stereotype.Component;

import java.util.concurrent.CopyOnWriteArrayList;

@Component
public class MyCopyOnWriteArrayList<T> extends CopyOnWriteArrayList<T> {
}
