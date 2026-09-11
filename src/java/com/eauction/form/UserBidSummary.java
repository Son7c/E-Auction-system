package com.eauction.form;

import java.sql.Timestamp;

public class UserBidSummary {
    private int auctionId;
    private String name;
    private String category;
    private String imageUrl;
    private double startingBid;
    private double currentHighestBid;
    private double userHighestBid;
    private Timestamp startTime;
    private Timestamp endTime;
    private String status;
    private int userBidCount;

    public UserBidSummary() {
    }

    public int getAuctionId() {
        return auctionId;
    }

    public void setAuctionId(int auctionId) {
        this.auctionId = auctionId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public double getStartingBid() {
        return startingBid;
    }

    public void setStartingBid(double startingBid) {
        this.startingBid = startingBid;
    }

    public double getCurrentHighestBid() {
        return currentHighestBid;
    }

    public void setCurrentHighestBid(double currentHighestBid) {
        this.currentHighestBid = currentHighestBid;
    }

    public double getUserHighestBid() {
        return userHighestBid;
    }

    public void setUserHighestBid(double userHighestBid) {
        this.userHighestBid = userHighestBid;
    }

    public Timestamp getStartTime() {
        return startTime;
    }

    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }

    public Timestamp getEndTime() {
        return endTime;
    }

    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getUserBidCount() {
        return userBidCount;
    }

    public void setUserBidCount(int userBidCount) {
        this.userBidCount = userBidCount;
    }

    public boolean isTopBidder() {
        return userHighestBid >= currentHighestBid && userHighestBid > 0;
    }

    public boolean isLive() {
        long now = System.currentTimeMillis();
        long start = startTime != null ? startTime.getTime() : 0;
        long end = endTime != null ? endTime.getTime() : Long.MAX_VALUE;
        return now >= start && now <= end;
    }

    public boolean isUpcoming() {
        long now = System.currentTimeMillis();
        long start = startTime != null ? startTime.getTime() : 0;
        return now < start;
    }

    public boolean isClosed() {
        long now = System.currentTimeMillis();
        long end = endTime != null ? endTime.getTime() : Long.MAX_VALUE;
        return now > end;
    }

    public String getBadgeLabel() {
        if (isClosed()) {
            return isTopBidder() ? "🏆 Won" : "⚪ Outbid (Ended)";
        }
        if (isUpcoming()) {
            return "⏱ Upcoming";
        }
        return isTopBidder() ? "🟢 Winning" : "🔴 Outbid";
    }

    public String getBadgeClass() {
        if (isClosed()) {
            return isTopBidder() ? "badge-won" : "badge-lost";
        }
        if (isUpcoming()) {
            return "badge-upcoming";
        }
        return isTopBidder() ? "badge-winning" : "badge-outbid";
    }
}
