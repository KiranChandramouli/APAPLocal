* @ValidationCode : MjoxNTQ0Mzc3NDM2OkNwMTI1MjoxNzA0MzcxMTg3MTQxOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Jan 2024 17:56:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.OFFICER.OF.COMPANY.SELECT
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine extracts the data from CUSTOMER as per the mapping provided
*
* Developed By          : Kalyani L K, Capgemini
*
* Development Reference : REGN5-GR04
*
* Attached To           : Batch - BNK/REDO.B.OFFICER.OF.COMPANY
*
* Attached As           : Multi Threaded Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#2 : NA
*
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* REGN5-GR04             Kalyani L K                     2014-02-18           Initial Draft
* PACS00361956           Ashokkumar.V.P                  23/02/2015           Optimized the relation between the customer
* Date                  who                   Reference
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*18/01/2024         Suresh                 R22 AUTO Conversion   CALL routine Modified
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.OFFICER.OF.COMPANY.COMMON
    $USING EB.Service ;* R22 AUTO CONVERSION
*-----------------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para of the program, from where the execution of the code starts
**
    GOSUB PROCESS.PARA

RETURN
*-----------------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* In this para of the program, the main processing starts
**
    CURR.MONTH = TODAY[5,2]
    CURR.MONTH = CURR.MONTH
    CURR.MONTH = TRIM(CURR.MONTH,'0','L')

    LOCATE CURR.MONTH IN FIELD.GEN.VAL<1> SETTING FOUND.POS ELSE
        RETURN
    END

    SEL.TEMP = ''; SEL.CONT.LST = ''; SEL.CMD = ''; SEL.LIST = ''; NO.OF.REC = ''
    RET.CODE = ''; SEL.PRT2 = ''; SE.LIST1 = ''
    SEL.TEMP = "SSELECT ":FN.REDO.GR.REP.CUST:" WITH @ID LIKE ":REPORT.NAME:"..."
    EXECUTE SEL.TEMP RTNLIST SE.LIST1
    SEL.PRT2 = 'QSELECT ':FN.REDO.GR.REP.CUST
    EXECUTE SEL.PRT2 PASSLIST SE.LIST1 RTNLIST SEL.CONT.LST

    SEL.CMD = "SELECT ":FN.RELATION.CUSTOMER
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

*CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST);* R22 AUTO CONVERSION

RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
