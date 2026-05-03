# 📡 SystemVerilog UART Core

Hey there! Welcome to my UART (Universal Asynchronous Receiver-Transmitter) project. 

I built this from scratch using **SystemVerilog** to practice clean RTL design principles and get hands-on with Finite State Machine (FSM) architectures. If you need a lightweight, reliable way to get serial data in and out of your FPGA or ASIC project, this core has you covered.

## ✨ Why this design?
Instead of just throwing bits over a wire, I wanted to make sure this design was actually robust enough for real-world hardware. Here is what makes it tick:
* **FSM-Driven:** Both the transmitter and receiver run on their own dedicated State Machines. This keeps the logic organized, predictable, and easy to debug.
* **16x Oversampling:** The real world is noisy. Instead of just checking the receive line once per bit, the receiver samples it 16 times and grabs the data right in the middle of the "eye." This helps it tolerate slight clock drifts and line noise.
* **Highly Parameterizable:** You don't need to rewrite the code if your system clock changes. Just tweak the parameters in the baud rate generator, and you're good to go!

---

## 🧩 How the Pieces Fit Together

The project is broken down into three main modules to keep things modular and clean:

### 1. The Heartbeat: `baudrate_sv`
This is the timing engine. It takes the main system clock and slows it down to generate two specific pulses: a slower one for transmitting (`tx_en`) and a faster one for our receiver's oversampling (`rx_en`). 
* **Customizing it:** Just change `TX_MAX` and `RX_MAX` to match your board's clock frequency and your desired baud rate.

### 2. The Talker: `transmitter_sv`
Give this module an 8-bit byte, pulse the write enable (`wr_en`), and it does the rest. 
* It waits in `IDLE_STATE`.
* When triggered, it drops the line low (`START_STATE`).
* It cleanly shifts out your 8 bits of data one by one (`DATA_STATE`).
* Finally, it pulls the line high to finish the frame (`STOP_STATE`) and lets you know it's no longer `busy`.

### 3. The Listener: `receiver_sv`
This is where the 16x oversampling magic happens. It's constantly watching the `rx` line for activity.
* **Finding the start:** Once the line drops, it waits for exactly half a bit period to ensure it's a real start bit and not just a glitch.
* **Reading the data:** It then perfectly aligns itself to sample the dead-center of the next 8 data bits.
* **Delivery:** Once the stop bit is detected, it raises the `ready` flag to let your system know a fresh byte of `data_out` is waiting to be read.

## 🚀 How to use it
To drop this into your own design, just instantiate the three modules in your top-level file. Route the `tx_en` from the baud rate generator into the transmitter, and route the `rx_en` into the receiver's `clk_en` port. Wire up your inputs and outputs, and you're ready to communicate!

Feel free to poke around the code, use it in your own projects, or reach out if you have any questions.
