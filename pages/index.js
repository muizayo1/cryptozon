import {ethers} from "ethers";
import { useEffect, useState} from "react";
import axios from "axios";
import Web3Modal from "web3modal";
import styles from '../styles/Home.module.css'
import { nftAdress,nftmarketaddress } from "./config";


export default function Home() {
  return (
    <div className={styles.container}>
     <h1>Welcome Home</h1>
    </div>
  )
}
