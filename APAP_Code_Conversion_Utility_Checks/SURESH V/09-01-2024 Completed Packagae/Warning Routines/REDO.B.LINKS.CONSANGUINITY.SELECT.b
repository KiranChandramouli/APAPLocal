* @ValidationCode : Mjo5NjE0MzM5NDU6Q3AxMjUyOjE3MDQxNzMxNTc4NzI6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 Jan 2024 10:55:57
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
SUBROUTINE REDO.B.LINKS.CONSANGUINITY.SELECT
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine extracts the data from CUSTOMER as per the mapping provided
*
* Developed By          : Kalyani L K, Capgemini
*
* Development Reference : REGN6-GR05
*
* Attached To           : Batch - BNK/REDO.B.LINKS.CONSANGUINITY
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
* REGN6-GR05             Kalyani L K                     2014-02-18           Initial Draft
*
* PACS00361957           Ashokkumar.V.P                  19/02/2015           Optimized the relation between the customer
* Date                  who                   Reference
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*02/01/2024         Suresh                R22 Manual Conversion   Change F.READ to F.READU
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.LINKS.CONSANGUINITY.COMMON
    
    $USING EB.Service ;*R22 Manual Conversion
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
    CURR.MONTH = CURR.MONTH + 1 - 1

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

*    CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST) ;*R22 Manual Conversion
RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
