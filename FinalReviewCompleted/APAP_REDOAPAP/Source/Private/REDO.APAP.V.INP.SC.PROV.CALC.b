* @ValidationCode : MjoyMTQzMDg1NDkxOkNwMTI1MjoxNjg0ODM2MDU0MTAzOklUU1M6LTE6LTE6NjE0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 614
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.V.INP.SC.PROV.CALC
*-------------------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : A.C.Rajkumar
* Program Name  : REDO.APAP.V.INP.SC.PROV.CALC
* ODR NUMBER    : ODR-2010-09-0167
*-------------------------------------------------------------------------------------------------
* Description   : This is an input routine attached to the VERSION - SEC.TRADE,APAP.BUY.OWN.BOOK
*                 and SEC.TRADE,APAP.SELL.OWN.BOOK, the routine checks if the customers SECTOR
*                 is exempted or not, checks if the security code is marked in the provision
*                 parameter or not  and also checks if there are multiple issuers
* In parameter  : None
* out parameter : None
*--------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*   DATE             WHO            REFERENCE         DESCRIPTION
* 22-09-2010      A.C.Rajkumar   ODR-2010-09-0167   Initial Creation
* 10-05-2011      Sudharsanan S   PACS00061656         Modification
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*18-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM ,F.READ to CACHE.READ, ++ to +=
*18-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



* -------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.SECTOR
    $INSERT I_F.EB.RATING
    $INSERT I_F.REDO.H.PROVISION.PARAMETER

    GOSUB OPEN.PARA
    GOSUB INIT
    GOSUB PROCESS.PARA
RETURN

*----------------------------------------------------------------------------
OPEN.PARA:
*=========

    FN.SECURITY.MASTER = 'F.SECURITY.MASTER'
    F.SECURITY.MASTER  = ''
    CALL OPF(FN.SECURITY.MASTER, F.SECURITY.MASTER)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.SECTOR = 'F.SECTOR'
    F.SECTOR  = ''
    CALL OPF(FN.SECTOR, F.SECTOR)

    FN.REDO.H.PROVISION.PARAMETER = 'F.REDO.H.PROVISION.PARAMETER'
    F.REDO.H.PROVISION.PARAMETER  = ''
    CALL OPF(FN.REDO.H.PROVISION.PARAMETER, F.REDO.H.PROVISION.PARAMETER)

    FN.EB.RATING = 'F.EB.RATING'
    F.EB.RATING  = ''
    CALL OPF(FN.EB.RATING, F.EB.RATING)

RETURN

*---------------------------------------------------------------------------
INIT:
*====

    R.REDO.H.PROVISION.PARAMETER = ''
    R.SECURITY.MASTER        = ''
    R.CUSTOMER                   = ''
    R.REC.SECTOR                 = ''

RETURN

*----------------------------------------------------------------------------
PROCESS.PARA:
*============
    GOSUB CHECK.PROV.CALC

    IF NOT (Y.FLAG) THEN
        RETURN
    END
    GOSUB GET.ISSUER.SECTOR

    GOSUB CHECK.EXEMPTED.SECTOR

    GOSUB CHECK.PROV.PERC

    IF ETEXT THEN
        RETURN
    END

    GOSUB CHECK.CUST.TRANS.CODE

RETURN

*----------------------------------------------------------------------------
CHECK.PROV.CALC:
*===============

    GOSUB FIND.MULTI.LOCAL.REF

    IF R.NEW(SC.SBS.LOCAL.REF)<1,LOC.L.SC.PROV.CALC.POS> EQ 'YES' THEN ;*R22 AUTO CODE CONVERSION
        Y.FLAG = 1
    END

RETURN

*----------------------------------------------------------------------------
GET.ISSUER.SECTOR:
*=================

    SECURITY.MASTER.ID = R.NEW(SC.SBS.SECURITY.CODE)
    CALL F.READ(FN.SECURITY.MASTER, SECURITY.MASTER.ID, R.SECURITY.MASTER, F.SECURITY.MASTER, Y.ERR.SECURITY.MASTER)
    IF R.SECURITY.MASTER THEN
        CUSTOMER.ID = R.SECURITY.MASTER<SC.SCM.ISSUER,1>
*PACS00061656-S 19 MAY
        IF CUSTOMER.ID EQ '' THEN
            AF = SC.SBS.SECURITY.CODE
            ETEXT = 'EB-CUSTOMER.NOT.FOUND'
            CALL STORE.END.ERROR
        END
*PACS00061656-E 19 MAY
        Y.CUSTOMER.COUNT = COUNT(CUSTOMER.ID,@VM)
        IF Y.CUSTOMER.COUNT GT '1' THEN
            AF = SC.SBS.SECURITY.CODE
            ETEXT = 'EB-MULTI.ISSUER'
            CALL STORE.END.ERROR
        END

        CALL F.READ(FN.CUSTOMER, CUSTOMER.ID, R.CUSTOMER, F.CUSTOMER, Y.ERR.CUSTOMER)
        IF R.CUSTOMER THEN
            SECTOR.ID = R.CUSTOMER<EB.CUS.SECTOR>
        END
    END

RETURN

*--------------------------------------------------------------------------------
CHECK.EXEMPTED.SECTOR:
*=====================
*PACS00061656 -S
    REDO.H.PROVISION.PARAMETER.ID = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.H.PROVISION.PARAMETER,REDO.H.PROVISION.PARAMETER.ID,R.REDO.H.PROVISION.PARAMETER,Y.ERR.REDO.H.PROVISION.PARAMETER)
*PACS00061656 -E
    IF NOT(R.REDO.H.PROVISION.PARAMETER) THEN
        ETEXT = 'EB-PARAM.NOT.DEFINED'
        CALL STORE.END.ERROR
    END ELSE
        Y.EXEMP.SEC = R.REDO.H.PROVISION.PARAMETER<PROV.EXEMP.SECTOR>
        LOCATE SECTOR.ID IN Y.EXEMP.SEC<1,1> SETTING Y.SEC.POS THEN
            GOSUB RAISE.ERROR
        END
    END
RETURN

*------------------------------------------------------------------------------------
RAISE.ERROR:
*===========

    CALL CACHE.READ(FN.SECTOR, SECTOR.ID, R.SECTOR, Y.ERR.SECTOR) ;*R22 AUTO CODE CONVERSION
    IF R.SECTOR THEN
        AF = SC.SBS.SECURITY.CODE
        ETEXT = 'EB-EXEMP.SECTOR':@FM:R.SECTOR<EB.SEC.DESCRIPTION>
        CALL STORE.END.ERROR
    END

RETURN

*--------------------------------------------------------------------------------------
CHECK.PROV.PERC:
*================
    VAR.PRO.RATING= R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.PRO.RATING.POS>
    IF NOT(VAR.PRO.RATING) THEN
        AF    = SC.SBS.SECURITY.CODE
        ETEXT = 'EB-NO.PROV.PERC'
        CALL STORE.END.ERROR
    END
RETURN
*----------------------------------------------------------------------------------------
CHECK.CUST.TRANS.CODE:
*=====================

*PACS00061656 - S
    Y.CUST.TRANS.CODE = R.NEW(SC.SBS.CUST.TRANS.CODE)
    Y.CODE.COUNT = DCOUNT(Y.CUST.TRANS.CODE,@VM)
    Y.COUNT = 1 ; Y.CODE.FLAG = '' ; Y.FLAG.DR = '' ; Y.FLAG.CR = ''
    LOOP
    WHILE Y.COUNT LE Y.CODE.COUNT
        LOCATE Y.CUST.TRANS.CODE<1,Y.COUNT> IN R.REDO.H.PROVISION.PARAMETER<PROV.SEC.DR.CODE,1> SETTING Y.DR.POS ELSE
            LOCATE Y.CUST.TRANS.CODE<1,Y.COUNT> IN R.REDO.H.PROVISION.PARAMETER<PROV.SEC.CR.CODE,1> SETTING Y.CR.POS ELSE
                Y.CODE.FLAG = 1
            END
        END
        IF Y.CODE.FLAG THEN
            AF = SC.SBS.CUST.TRANS.CODE
            AV = Y.COUNT
            ETEXT = 'EB-INVALID.TRANS.CODE'
            CALL STORE.END.ERROR
            RETURN
        END
        Y.COUNT += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT
    GOSUB CHECK.BROK.TRANS.CODE
RETURN
*--------------------------------------------------------------------------------------------
CHECK.BROK.TRANS.CODE:
*--------------------------------------------------------------------------------------------
    Y.BROK.TRANS.CODE = R.NEW(SC.SBS.BR.TRANS.CODE)
    Y.BR.CODE.COUNT = DCOUNT(Y.BROK.TRANS.CODE,@VM)
    Y.BR.COUNT = 1 ; Y.CODE.FLAG = ''
    LOOP
    WHILE Y.BR.COUNT LE Y.BR.CODE.COUNT
        LOCATE Y.BROK.TRANS.CODE<1,Y.BR.COUNT> IN R.REDO.H.PROVISION.PARAMETER<PROV.SEC.DR.CODE,1> SETTING Y.DR.POS ELSE
            LOCATE Y.BROK.TRANS.CODE<1,Y.BR.COUNT> IN R.REDO.H.PROVISION.PARAMETER<PROV.SEC.CR.CODE,1> SETTING Y.CR.POS ELSE
                Y.CODE.FLAG = 1
            END
        END
        IF Y.CODE.FLAG THEN
            AF = SC.SBS.BR.TRANS.CODE
            AV = Y.BR.COUNT
            ETEXT = 'EB-INVALID.TRANS.CODE'
            CALL STORE.END.ERROR
            RETURN
        END
        Y.BR.COUNT += 1
    REPEAT
*PACS00061656 - E
RETURN
*---------------------------------------------------------------------------------------
FIND.MULTI.LOCAL.REF:
*====================

    APPL.ARRAY = 'SEC.TRADE':@FM:'CUSTOMER'
    FLD.ARRAY  = 'L.SC.PROV.CALC':@FM:'L.CU.PRO.RATING'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY, FLD.ARRAY, FLD.POS)
    LOC.L.SC.PROV.CALC.POS = FLD.POS<1,1>
    LOC.L.CU.PRO.RATING.POS = FLD.POS<2,1>

RETURN
