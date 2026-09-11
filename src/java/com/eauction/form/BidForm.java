package com.eauction.form;

import java.sql.Timestamp;

public class BidForm {
    private int bidId;
    private int bidderId;
    private int auctionId;
    private double bidAmount;
    private Timestamp bidTime;
    private String bidderName;

    public BidForm() {
    }

    public BidForm(int bidderId, int auctionId, double bidAmount, Timestamp bidTime) {
        this.bidderId = bidderId;
        this.auctionId = auctionId;
        this.bidAmount = bidAmount;
        this.bidTime = bidTime;
    }

    public int getBidId() {
        return bidId;
    }

    public void setBidId(int bidId) {
        this.bidId = bidId;
    }

    public int getBidderId() {
        return bidderId;
    }

    public void setBidderId(int bidderId) {
        this.bidderId = bidderId;
    }

    public int getAuctionId() {
        return auctionId;
    }

    public void setAuctionId(int auctionId) {
        this.auctionId = auctionId;
    }

    public double getBidAmount() {
        return bidAmount;
    }

    public void setBidAmount(double bidAmount) {
        this.bidAmount = bidAmount;
    }

    public Timestamp getBidTime() {
        return bidTime;
    }

    public void setBidTime(Timestamp bidTime) {
        this.bidTime = bidTime;
    }

    public String getBidderName() {
        return bidderName;
    }

    public void setBidderName(String bidderName) {
        this.bidderName = bidderName;
    }
}
