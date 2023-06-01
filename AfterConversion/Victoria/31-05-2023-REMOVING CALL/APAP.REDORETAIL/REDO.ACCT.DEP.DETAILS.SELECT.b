* @ValidationCode : MjoyMTAzMDI1NjA5OkNwMTI1MjoxNjgxMjc2NTU2MzEzOklUU1M6LTE6LTE6LTEwOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:45:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -10
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION              NO CHANGES
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------------------------------------------------------
SUBROUTINE REDO.ACCT.DEP.DETAILS.SELECT
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.RELATION
    $INSERT I_F.CATEGORY
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT.CLASS
    $INSERT I_F.REDO.AML.PARAM
    $INSERT I_REDO.ACCT.DEP.DETAILS.COMMON
    $INSERT I_F.REDO.H.TELLER.TXN.CODES

    GOSUB SELECT.PROCES
*
RETURN
*------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT.PROCES:
*-------------
    CALL EB.CLEAR.FILE(FN.REDO.APAP.BKP.REP55,F.REDO.APAP.BKP.REP55)

    SEL.CMD = " SELECT ": FN.ACCT.ENT.LWORK.DAY
    SEL.LIST = ''
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR.CODE)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
*
RETURN
*-----------------------------------------------------------------------------------------------------------------
END
