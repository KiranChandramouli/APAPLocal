* @ValidationCode : MjotMTE2NzcyOTMxMTpDcDEyNTI6MTY4MzA4MTcwMzEzMjpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 03 May 2023 08:11:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

SUBROUTINE  REDO.PW.PROCESS.CONTACT(R.DATA,L.PROCESS.ID)
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This PW routine will map the Process Id
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*12/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*12/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
* INPUT/OUTPUT:
*--------------
* IN  : R.DATA
* OUT : L.CUST.ID
*-------------------------------------------------------------------------
*   Date               who           Reference            Description
* 13-SEP-2011     SHANKAR RAJU     ODR-2011-07-0162      Initial Creation
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
    SEL.CMD := " AND CONTACT.DIRECTION EQ OUTWARD AND CONTACT.DESC EQ 'Outbound Campaign Loans (AA)' AND CONTACT.STATUS EQ ACEPTA"

    CALL EB.READLIST(SEL.CMD,CR.CONTACT.ID,'',NO.OF.REC,CR.ERR)

    L.PROCESS.ID = CR.CONTACT.ID<NO.OF.REC>

RETURN
END
