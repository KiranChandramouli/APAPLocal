* @ValidationCode : Mjo3NTg3MzUyNjE6Q3AxMjUyOjE2ODQzMjc5MzY2MDE6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 May 2023 18:22:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.B.CUSTOMER.RGA(CUSTOMER.ID)
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      : Nirmal.P
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description:
*-------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*   Date       Author              Modification Description
*
* 05/02/2015  Ashokkumar.V.P        PACS00368383 - New mapping changes

** 21-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 21-04-2023 Skanda R22 Manual Conversion - CALL RTN FORMAT MODIFIED
*--------------------------------------------------------------------------------

    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_F.CUSTOMER ;* R22 Auto conversion
    $INSERT I_F.COMPANY ;* R22 Auto conversion
    $INSERT I_REDO.B.CUSTOMER.RGA.COMMON ;* R22 Auto conversion
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON ;* R22 Auto conversion
    $USING APAP.LAPAP


    R.CUSTOMER = ''; CUS.ERR = ''
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    Y.GRP.RIESGO = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.GRP.RIESGO.POS>

    IF R.CUSTOMER NE '' AND Y.GRP.RIESGO NE '' THEN
        Y.CUSTOMER.ID   = CUSTOMER.ID
        Y.PRODUCT.GROUP = ''; Y.REL.CODE      = ''; OUT.ARR         = ''
*CALL REDO.S.REG.CUSTOMER.EXTRACT(Y.CUSTOMER.ID,Y.PRODUCT.GROUP,Y.REL.CODE,OUT.ARR)  ;*R22 MANUAL CODE CONVERSION
        CALL APAP.LAPAP.redoSRegCustomerExtract(Y.CUSTOMER.ID,Y.PRODUCT.GROUP,Y.REL.CODE,OUT.ARR)  ;*R22 MANUAL CODE CONVERSION
        GOSUB GET.COURT.DATE
        GOSUB GET.CUSTOMER.CODE
        GOSUB GET.COMPANY.DECTOR
        GOSUB GET.NAME.INITIAL
        CHANGE @SM TO @FM IN Y.GRP.RIESGO
        Y.GRP.RIESGO.MAX=DCOUNT(Y.GRP.RIESGO,@FM)

        Y.GRP.RIESGO.CNT=1
        LOOP
        WHILE Y.GRP.RIESGO.CNT LE Y.GRP.RIESGO.MAX
            C$SPARE(455)=RIGHT(Y.GRP.RIESGO<Y.GRP.RIESGO.CNT>,7)
            GOSUB MAP.RCL.RECORD
            Y.GRP.RIESGO.CNT += 1 ;* R22 Auto conversion
        REPEAT
    END
RETURN
*-----------------------------------------------------------------------------
GET.COURT.DATE:
*--------------
    Y.LST.CDAY = ''; Y.D = "-1C"
    Y.LST.CDAY = TODAY
    Y.LST.CDAY =Y.LST.CDAY[1,6]:'01'
    CALL CDT('',Y.LST.CDAY,Y.D)

    Y.COURT.DT     =Y.LST.CDAY[7,2]:'/':Y.LST.CDAY[5,2]:'/':Y.LST.CDAY[1,4]
    C$SPARE(451)   = Y.COURT.DT
RETURN
*-------------------------------------------------------------------------
GET.CUSTOMER.CODE:
*-----------------
    Y.CUST.CODE    = FIELD(OUT.ARR,@FM,1)
    C$SPARE(452)   = Y.CUST.CODE
RETURN
*--------------------------------------------------------------------------------
GET.COMPANY.DECTOR:
*------------------
    Y.COMP.DEBTOR  = FIELD(OUT.ARR,@FM,3)
    C$SPARE(453)   = Y.COMP.DEBTOR
RETURN
*------------------------------------------------------------------------------
GET.NAME.INITIAL:
*----------------
    Y.NAME.INITIAL = FIELD(OUT.ARR,@FM,4)
    C$SPARE(454) = Y.NAME.INITIAL
RETURN
*------------------------------------------------------------------------------
MAP.RCL.RECORD:
*--------------
    MAP.FMT = 'MAP'
    ID.RCON.L = 'REDO.RCL.RN15'
    APP = FN.CUSTOMER
    ID.APP = CUSTOMER.ID
    R.APP = R.CUSTOMER; R.RETURN.MSG = ''; ERR.MSG = ''
    CALL RAD.CONDUIT.LINEAR.TRANSLATION (MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    IF R.RETURN.MSG THEN
        WRK.FILE.ID = CUSTOMER.ID:'.':Y.GRP.RIESGO.CNT
        CALL F.WRITE(FN.DR.REG.RIEN15.WORKFILE,WRK.FILE.ID,R.RETURN.MSG)
    END
RETURN

END
