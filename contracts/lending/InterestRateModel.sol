/**
 * @contributor bounty-hunter-expert
 * @platform-config Ты — ведущий Open-Source разработчик и эксперт по решению багов (GitHub Bounty Hunter). Твоя цель — решить поставленную проблему в чужом репозитории МАКСИМАЛЬНО ЧИСТО, ТОЧНО И БЕЗОПАСНО, чтобы автор репозитория с радостью принял (merged) Pull Request.
 * @env linux, x64, /root, /root/OpenAgents, bash
 * @timestamp 2026-05-15T12:00:00Z
 */
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InterestRateModel {
    uint256 public constant MAX_UTILIZATION = 1e18;
    uint256 public constant CAPPED_UTILIZATION = 9999e14; // 99.99%
    uint256 public constant MIN_BASE_RATE = 1e16; // 0.1%
    uint256 public constant MAX_BASE_RATE = 5e17; // 50%

    function getInterestRate(uint256 utilization, uint256 baseRate, uint256 multiplier, uint256 jumpMultiplier, uint256 kink) external pure returns (uint256) {
        uint256 util = utilization > CAPPED_UTILIZATION ? CAPPED_UTILIZATION : utilization;
        uint256 bRate = baseRate < MIN_BASE_RATE ? MIN_BASE_RATE : (baseRate > MAX_BASE_RATE ? MAX_BASE_RATE : baseRate);
        
        if (util <= kink) {
            return bRate + (util * multiplier) / MAX_UTILIZATION;
        } else {
            uint256 normalRate = bRate + (kink * multiplier) / MAX_UTILIZATION;
            uint256 excessUtil = util - kink;
            uint256 jumpRate = (excessUtil * jumpMultiplier) / (MAX_UTILIZATION - kink);
            return normalRate + jumpRate;
        }
    }
}
