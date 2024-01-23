* @ValidationCode : MjotOTE1MjcxNTM6Q3AxMjUyOjE3MDQ3MDY2MDY0MTA6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Jan 2024 15:06:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.UPD.USER.LOG.SELECT
*-------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.UPD.USER.LOG.SELECT
*-------------------------------------------------------------------------
*Description  : This is a validation routine to check the card is valid or
*               This routine has to be attached to versions used in ATM tr
*               to find out whether the status entered is valid or not
*In Parameter : N/A
*Out Parameter: N/A
*-------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Descript
*   ------         ------               -------------            ---------
* 01 NOV  2010     SRIRAMAN.C                                     Initial
* 01 May 2015      Ashokkumar            PACS00310287             Removed multiple filtering and added in main routine.
* Date                  who                   Reference
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*18/01/2024         Suresh                 R22 UTILITY AUTO CONVERSION   CALL routine Modified
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.UPD.USER.LOG.COMMON
    $USING EB.Service


    SEL.CMD.1 = "SELECT ":FN.PROTO
    SEL.CMD.1 : = " WITH APPLICATION EQ 'SIGN.ON'"
    CALL EB.READLIST(SEL.CMD.1,SEL.LIST,'',NO.REC,RET.CODE)
*    CALL BATCH.BUILD.LIST("",SEL.LIST)
    EB.Service.BatchBuildList("",SEL.LIST);* R22 UTILITY AUTO CONVERSION
RETURN
END
