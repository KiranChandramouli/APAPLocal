* @ValidationCode : MjotNzAxNDU0Nzc6Q3AxMjUyOjE2ODI1Mjg0NzAwOTk6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Apr 2023 22:31:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.PW.PROCESS.CC.CONTACT(R.DATA,L.PROCESS.ID)
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This PW routine will map the Process Id

* INPUT/OUTPUT:
*--------------
* IN  : R.DATA
* OUT : L.CUST.ID
*-------------------------------------------------------------------------
*   Date               who                     Reference                  Description
* 13-SEP-2011     SHANKAR RAJU              ODR-2011-07-0162             Initial Creation
*18-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*18-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_PW.COMMON
    $INSERT I_F.PW.PROCESS

    GOSUB INIT
    GOSUB PROCESS

RETURN

INIT:
*----

    FN.CR.CONTACT.LOG = "F.CR.CONTACT.LOG"
    F.CR.CONTACT.LOG  = ""
    CALL OPF(FN.CR.CONTACT.LOG,F.CR.CONTACT.LOG)

RETURN

PROCESS:
*-------

    SEL.CMD = "SELECT ":FN.CR.CONTACT.LOG:" WITH CONTACT.CLIENT EQ ":R.NEW(PW.PROC.CUSTOMER):" AND CONTACT.CHANNEL EQ CALLCENTRE"
    SEL.CMD := " AND CONTACT.DIRECTION EQ OUTWARD AND CONTACT.DESC EQ 'Outbound Campaign for Credit Card' AND CONTACT.STATUS EQ ACEPTA"

    CALL EB.READLIST(SEL.CMD,CR.CONTACT.ID,'',NO.OF.REC,CR.ERR)

    L.PROCESS.ID = CR.CONTACT.ID<NO.OF.REC>

RETURN
END
