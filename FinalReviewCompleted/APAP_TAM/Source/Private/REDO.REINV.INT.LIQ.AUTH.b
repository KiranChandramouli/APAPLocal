* @ValidationCode : MjotNTMxMDA0OTg1OkNwMTI1MjoxNjgxMDU2NDg1NDAyOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Apr 2023 21:38:05
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
SUBROUTINE REDO.REINV.INT.LIQ.AUTH

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.REINV.INT.LIQ.AUTH
*--------------------------------------------------------------------------------
* Description: This Authorisation routine is to store the current record to populate
* values in next version
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 04-Jul-2011    H GANESH     PACS00072695_N.11 INITIAL CREATION
* 10.04.2023   Conversion Tool       R22        Auto Conversion     - No changes
* 10.04.2023   Shanmugapriya M       R22        Manual Conversion   - No changes
*

*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
*$INCLUDE GLOBUS.BP I_System


    GOSUB LOC.REF
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
LOC.REF:
*---------------------------------------------------------------------------------
LOC.REF.APPLICATION="ACCOUNT":
    LOC.REF.FIELDS='L.AC.AZ.ACC.REF'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AC.AZ.ACC.REF = LOC.REF.POS<1,1>

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------


*MATBUILD Y.CURRENT.REC FROM R.NEW,1,189
*CHANGE FM TO '*' IN Y.CURRENT.REC
*CALL System.setVariable("CURRENT.REC",Y.CURRENT.REC)
*CALL System.setVariable("CURRENT.ID",ID.NEW)



    R.ACCOUNT = ''
    R.ACCOUNT<AC.INTEREST.LIQU.ACCT> = ID.NEW


    APPLICATION.NAME = 'ACCOUNT'
    OFS.FUNCTION1 = 'I'
    PROCESS1 = 'PROCESS'
    OFS.VERSION1 = ''
    GTSMODE1 = ''
    NO.OF.AUTH1 = '0'
    TRANSACTION.ID1 = R.NEW(AC.LOCAL.REF)<1,POS.L.AC.AZ.ACC.REF>
    OFS.RECORD1 = ''
    VERSION1 = 'ACCOUNT,RE'
    MSG.ID1 = ''
    OPTION1 = ''

    CALL OFS.BUILD.RECORD(APPLICATION.NAME,OFS.FUNCTION1,PROCESS1,VERSION1,GTSMODE1,NO.OF.AUTH1,TRANSACTION.ID1,R.ACCOUNT,OFS.ACC)
    MSG.ID = ''
    ERR.OFS = ''
    OFS.SRC.ID = 'REINV.DEPOSIT'
    CALL OFS.POST.MESSAGE(OFS.ACC,MSG.ID,OFS.SRC.ID,ERR.OFS)

RETURN
END
