* @ValidationCode : MjotMTkyNTYyMTMxNzpDcDEyNTI6MTY4MTM2NTc5MDIxOTpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 11:33:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
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
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.UPD.USER.LOG.COMMON


    SEL.CMD.1 = "SELECT ":FN.PROTO
    SEL.CMD.1 : = " WITH APPLICATION EQ 'SIGN.ON'"
    CALL EB.READLIST(SEL.CMD.1,SEL.LIST,'',NO.REC,RET.CODE)
    CALL BATCH.BUILD.LIST("",SEL.LIST)
RETURN
END
