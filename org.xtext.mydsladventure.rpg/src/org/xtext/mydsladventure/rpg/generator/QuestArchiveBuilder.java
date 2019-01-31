package org.xtext.mydsladventure.rpg.generator;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.zip.ZipOutputStream;

import com.google.common.collect.Streams;

public class QuestArchiveBuilder {

	private ByteArrayOutputStream stream;
	private ZipOutputStream zipStream;
	
	public QuestArchiveBuilder() {
		stream = new ByteArrayOutputStream();
		zipStream = new ZipOutputStream(stream);
	}
	
	public QuestArchiveBuilder addFile(String name, String content) {
		ZipEntry entry = new ZipEntry(name);

		try {
			zipStream.putNextEntry(entry);
			zipStream.write(content.getBytes(), 0, content.getBytes().length);
			zipStream.closeEntry();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return this;
	}

	public QuestArchiveBuilder addFileFromStream(String name, InputStream stream) {		
		ZipEntry entry = new ZipEntry(name);

		try {
			zipStream.putNextEntry(entry);

			byte[] content = getBytesFromInputStream(stream);
			
			zipStream.write(content, 0, content.length);
			zipStream.closeEntry();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return this;
	}
	
	public QuestArchiveBuilder addFilesFromResources(String pattern) {
        for(String name : ResourceList.getResources(Pattern.compile(pattern))){
        	System.out.println(name);
			File file = new File(name);
			ZipEntry entry = new ZipEntry(file.getName());
			
			try {
				zipStream.putNextEntry(entry);
				
				byte[] content = Files.readAllBytes(Paths.get(file.getPath()));
				zipStream.write(content, 0, content.length);
			
				zipStream.closeEntry();
			} catch (ZipException e) {
			} catch (IOException e) {
				e.printStackTrace();
			}
        }
        
        return this;
	}
	
	public ByteArrayInputStream getStream() {
		try {
			zipStream.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return new ByteArrayInputStream(stream.toByteArray());
	}
	
	public static byte[] getBytesFromInputStream(InputStream is) throws IOException {
	    ByteArrayOutputStream os = new ByteArrayOutputStream(); 
	    byte[] buffer = new byte[0xFFFF];
	    for (int len = is.read(buffer); len != -1; len = is.read(buffer)) { 
	        os.write(buffer, 0, len);
	    }
	    return os.toByteArray();
	}
	
}