* @ValidationCode : MjotMzkzNDMyMjg2OkNwMTI1MjoxNjg0ODM2MDU0MDA2OklUU1M6LTE6LTE6NTc2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 576
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.V.INP.MM.PROV.CALC
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.V.INP.MM.PROV.CALC
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.V.INP.MM.PROV.CALC is an input routine attached to the VERSION - MM.MONEY.MARKET,PLACE,
*                    the routine checks if the customers SECTOR is exempted or not and also checks if the
*                    category is marked in the parameter table or not
*Linked With       : Version MM.MONEY.MARKET,APAP.PLACE
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : MM.MONEY.MARKET                As              I               Mode
*                    CUSTOMER                       As              I               Mode
*                    SECTOR                         As              I               Mode
*                    EB.RATING                      As              I               Mode
*                    REDO.H.PROVISION.PARAMETER     As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date                 Who                    Reference                  Description
*   ------               -----                 -------------               -------------
* 24 Sep 2010        Shiva Prasad Y        ODR-2010-09-0167 B.23B         Initial Creation
* 11 May 2011        Sudharsanan S             PACS00061656                 Modification
* 28-JUL-2011        JEEVA T                   PACS00093116                 Modification
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*18-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM ,F.READ to CACHE.READ
*18-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_F.CUSTOMER
    $INSERT I_F.SECTOR
    $INSERT I_F.EB.RATING
    $INSERT I_F.SEC.ACC.MASTER
    $INSERT I_F.REDO.H.PROVISION.PARAMETER
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
    GOSUB CHECK.PROT.VALUE

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.SECTOR = 'F.SECTOR'
    F.SECTOR = ''
    CALL OPF(FN.SECTOR,F.SECTOR)

    FN.EB.RATING = 'F.EB.RATING'
    F.EB.RATING = ''
    CALL OPF(FN.EB.RATING,F.EB.RATING)

    FN.SEC.ACC.MASTER = 'F.SEC.ACC.MASTER'
    F.SEC.ACC.MASTER = ''
    CALL OPF(FN.SEC.ACC.MASTER,F.SEC.ACC.MASTER)

    FN.REDO.H.PROVISION.PARAMETER = 'F.REDO.H.PROVISION.PARAMETER'
    F.REDO.H.PROVISION.PARAMETER = ''
    CALL OPF(FN.REDO.H.PROVISION.PARAMETER,F.REDO.H.PROVISION.PARAMETER)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    GOSUB CHECK.PROV.CALC

    IF NOT(Y.FLAG) THEN
        RETURN
    END

    GOSUB GET.CUSTOMER.SECTOR
    GOSUB CHECK.EXEMPTED.SECTOR
    GOSUB CHECK.PROV.PERC
    IF ETEXT THEN
        RETURN
    END

    GOSUB CHECK.ALLOWED.CATEGORY

RETURN
*--------------------------------------------------------------------------------------------------------
****************
CHECK.PROV.CALC:
****************
    GOSUB FIND.MULTI.LOCAL.REF

    IF R.NEW(MM.LOCAL.REF)<1,LOC.L.SC.PROV.CALC.POS> EQ 'YES' THEN
        Y.FLAG = 1
    END

RETURN
*--------------------------------------------------------------------------------------------------------
********************
GET.CUSTOMER.SECTOR:
********************
    CUSTOMER.ID = R.NEW(MM.CUSTOMER.ID)
    GOSUB READ.CUSTOMER
    SECTOR.ID = R.CUSTOMER<EB.CUS.SECTOR>

RETURN
*--------------------------------------------------------------------------------------------------------
**********************
CHECK.EXEMPTED.SECTOR:
**********************
*PACS00061656 - S
    REDO.H.PROVISION.PARAMETER.ID = 'SYSTEM'
    GOSUB READ.REDO.H.PROVISION.PARAMETER
*PACS00061656 -E

    IF NOT(R.REDO.H.PROVISION.PARAMETER) THEN
        ETEXT = 'EB-PARAM.NOT.DEFINED'
        CALL STORE.END.ERROR
    END

    Y.EXEMP.SEC = R.REDO.H.PROVISION.PARAMETER<PROV.EXEMP.SECTOR>

    LOCATE SECTOR.ID IN Y.EXEMP.SEC<1,1> SETTING Y.SEC.POS THEN
        GOSUB RAISE.ERROR
    END

RETURN
*--------------------------------------------------------------------------------------------------------
************
RAISE.ERROR:
************
    GOSUB READ.SECTOR

    AF = MM.CUSTOMER.ID
    ETEXT = 'EB-EXEMP.SECTOR':@FM:R.SECTOR<EB.SEC.DESCRIPTION>
    CALL STORE.END.ERROR

RETURN
*--------------------------------------------------------------------------------------------------------
****************
CHECK.PROV.PERC:
****************
* EB.RATING.ID = R.CUSTOMER<EB.CUS.CUSTOMER.RATING>
    VAR.PRO.RATING= R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.PRO.RATING.POS>
    IF NOT(VAR.PRO.RATING) THEN
        AF    = MM.CUSTOMER.ID
        ETEXT = 'EB-NO.PROV.PERC'
        CALL STORE.END.ERROR
    END
RETURN
*--------------------------------------------------------------------------------------------------------
***********************
CHECK.ALLOWED.CATEGORY:
***********************
*PACS00061656 - S
    Y.ALLOW.CATEG =  R.REDO.H.PROVISION.PARAMETER<PROV.MM.PROD.CATEG>
    CHANGE @VM TO @FM IN Y.ALLOW.CATEG
    VAR.MM.CATEG = R.NEW(MM.CATEGORY)
    LOCATE VAR.MM.CATEG IN Y.ALLOW.CATEG SETTING Y.CAT.POS ELSE
        AF = MM.CATEGORY
        ETEXT = 'EB-INVALID.TRANS.CODE'
        CALL STORE.END.ERROR
    END
*PACS00061656 -E
RETURN
*--------------------------------------------------------------------------------------------------------
**************
READ.CUSTOMER:
**************
* In this para of the code, file CUSTOMER is read
    R.CUSTOMER  = ''
    CUSTOMER.ER = ''
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
********************************
READ.REDO.H.PROVISION.PARAMETER:
********************************
* In this para of the code, file REDO.H.PROVISION.PARAMETER is read
    R.REDO.H.PROVISION.PARAMETER  = ''
    REDO.H.PROVISION.PARAMETER.ER = ''
    CALL CACHE.READ(FN.REDO.H.PROVISION.PARAMETER,REDO.H.PROVISION.PARAMETER.ID,R.REDO.H.PROVISION.PARAMETER,REDO.H.PROVISION.PARAMETER.ER)
RETURN
*--------------------------------------------------------------------------------------------------------
************
READ.SECTOR:
************
* In this para of the code, file SECTOR is read
    R.SECTOR  = ''
    SECTOR.ER = ''
    CALL CACHE.READ(FN.SECTOR, SECTOR.ID, R.SECTOR, SECTOR.ER) ;*R22 AUTO CODE CONVERSION

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    APPL.ARRAY = 'MM.MONEY.MARKET':@FM:'CUSTOMER'
    FLD.ARRAY  = 'L.SC.PROV.CALC':@VM:'L.MM.OWN.PORT':@FM:'L.CU.PRO.RATING'
    FLD.POS    = ''

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    LOC.L.SC.PROV.CALC.POS = FLD.POS<1,1>
    L.MM.OWN.PORT.POS      = FLD.POS<1,2>
    LOC.L.CU.PRO.RATING.POS = FLD.POS<2,1>

RETURN
*--------------------------------------------------------------------------------------------------------
************starts*PACS00093116*********************

*--------------------------------------------------------------------------------------------------------
CHECK.PROT.VALUE:
*--------------------------------------------------------------------------------------------------------
    Y.PORT.ID = R.NEW(MM.LOCAL.REF)<1,L.MM.OWN.PORT.POS>
    R.SEC.ACC.MASTER = ''
    CALL F.READ(FN.SEC.ACC.MASTER,Y.PORT.ID,R.SEC.ACC.MASTER,F.SEC.ACC.MASTER,Y.ERR.PORT)
    IF NOT(R.SEC.ACC.MASTER) THEN
        AF = MM.LOCAL.REF
        AV = L.MM.OWN.PORT.POS
        ETEXT = 'EB-INVALID.PORT.CODE'
        CALL STORE.END.ERROR
    END
RETURN
*--------------------------------------------------------------------------------------------------------
**************ends PACS00093116********************
END       ;* End of Program
