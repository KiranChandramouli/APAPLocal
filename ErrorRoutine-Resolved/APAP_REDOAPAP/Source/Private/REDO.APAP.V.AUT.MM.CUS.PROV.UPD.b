* @ValidationCode : MjotMTUyNjc1MTI0NjpDcDEyNTI6MTY4NjIyNDI1NDMyODpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 08 Jun 2023 17:07:34
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
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.V.AUT.MM.CUS.PROV.UPD
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.V.AUT.MM.CUS.PROV.UPD
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.V.AUT.MM.CUS.PROV.UPD is an authorisation routine attached to the VERSION
*                    - MM.MONEY.MARKET,PLACE, the routine updates the local file REDO.H.CUSTOMER.PROVISION
*                    with required values
*Linked With       : Version MM.MONEY.MARKET,PLACE
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : MM.MONEY.MARKET                As              I               Mode
*                    CUSTOMER                       As              I               Mode
*                    SECTOR                         As              I               Mode
*                    REDO.H.PROVISION.PARAMETER     As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date                 Who                    Reference                  Description
*   ------               -----                 -------------               -------------
* 24 Sep 2010        Shiva Prasad Y        ODR-2010-09-0167 B.23B         Initial Creation
* 14 May 2011        Sudharsanan S           PACS00061656                REDO.H.PROVISION.PARAMETER - @ID Changed to "SYSTEM"
* 10 FEB 2012        Jeeva T                 PACS00172864                Making principal and interst value as absolute
* 08 Jun 2023        Saranya               R22 Manual conversion         commented the unused GOSUB - UPDATE.MM.DETAILS
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_F.USER
    $INSERT I_F.REDO.H.PROVISION.PARAMETER
    $INSERT I_F.REDO.H.CUSTOMER.PROVISION
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened

    FN.REDO.H.PROVISION.PARAMETER = 'F.REDO.H.PROVISION.PARAMETER'
    F.REDO.H.PROVISION.PARAMETER  = ''
    CALL OPF(FN.REDO.H.PROVISION.PARAMETER,F.REDO.H.PROVISION.PARAMETER)

    FN.REDO.H.CUSTOMER.PROVISION = 'F.REDO.H.CUSTOMER.PROVISION'
    F.REDO.H.CUSTOMER.PROVISION = ''
    CALL OPF(FN.REDO.H.CUSTOMER.PROVISION,F.REDO.H.CUSTOMER.PROVISION)

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
    GOSUB READ.PROVISION.PARAMETER
    GOSUB CHECK.CUSTOMER.PROVISION
    GOSUB UPDATE.AUDIT.FIELDS

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
*************************
READ.PROVISION.PARAMETER:
*************************
*PACS00061656 -S
    REDO.H.PROVISION.PARAMETER.ID = 'SYSTEM'
    GOSUB READ.REDO.H.PROVISION.PARAMETER
*PACS00061656 -E

RETURN
*--------------------------------------------------------------------------------------------------------
*************************
CHECK.CUSTOMER.PROVISION:
*************************

    REDO.H.CUSTOMER.PROVISION.ID = R.NEW(MM.CUSTOMER.ID)
    GOSUB READ.REDO.H.CUSTOMER.PROVISION

    IF NOT(R.REDO.H.CUSTOMER.PROVISION) THEN
        GOSUB CREATE.CUSTOMER.PROVISION
    END ELSE
        GOSUB UPDATE.CUSTOMER.PROVISION
    END

RETURN
*--------------------------------------------------------------------------------------------------------
**************************
CREATE.CUSTOMER.PROVISION:
**************************
    Y.AF.POS = 1
    Y.AV.POS = 1
    GOSUB WRITE.CUS.PROV

RETURN
*--------------------------------------------------------------------------------------------------------
**************************
UPDATE.CUSTOMER.PROVISION:
**************************
*    LOCATE ID.NEW IN R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.CONT.ID,1> SETTING Y.MM.POS THEN
*        GOSUB UPDATE.MM.DETAILS
*    END ELSE
    GOSUB ADD.MM.DETAILS
*    END

RETURN
*--------------------------------------------------------------------------------------------------------
*******************
*UPDATE.MM.DETAILS:;* R22 Manual conversion - this GOSUB call was commented. Hence, commented GOSUB
*******************
*Y.AF.POS = Y.MM.POS
*    Y.AV.POS = 1
*    GOSUB WRITE.CUS.PROV
*
*RETURN
*--------------------------------------------------------------------------------------------------------
***************
ADD.MM.DETAILS:
***************
    Y.AF.POS = DCOUNT(R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.CONT.ID>,@VM) + 1
    Y.AV.POS = 1
    GOSUB WRITE.CUS.PROV

RETURN
*--------------------------------------------------------------------------------------------------------
***************
WRITE.CUS.PROV:
***************


    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.CONT.ID,Y.AF.POS>               = ID.NEW
    Y.CHECK=R.NEW(MM.LOCAL.REF)<1,LOC.L.MM.OWN.PORT.POS>
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.PORTFOLIO.ID,Y.AF.POS,Y.AV.POS> = R.NEW(MM.LOCAL.REF)<1,LOC.L.MM.OWN.PORT.POS>
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.PROV.DATE,Y.AF.POS,Y.AV.POS>    = TODAY
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.PROV.TIME,Y.AF.POS,Y.AV.POS>    = TIMEDATE()[1,8]
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>PACS00172864>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.PRINCIPAL,Y.AF.POS,Y.AV.POS>    = FMT(ABS(R.NEW(MM.PRINCIPAL)),'R2,')
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.MM.INTEREST,Y.AF.POS,Y.AV.POS>     = FMT(ABS(R.NEW(MM.TOT.INTEREST.AMT)),'R2,')

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>PACS00172864>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
RETURN
*--------------------------------------------------------------------------------------------------------
********************
UPDATE.AUDIT.FIELDS:
********************

    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.INPUTTER>   = C$T24.SESSION.NO:'_':OPERATOR

    Y.TEMP.TIME = OCONV(TIME(),"MTS")
    Y.TEMP.TIME = Y.TEMP.TIME[1,5]
    CHANGE ':' TO '' IN Y.TEMP.TIME

    Y.CHECK.DATE = DATE()
    Y.DATE.TIME = OCONV(Y.CHECK.DATE,"DY2"):FMT(OCONV(Y.CHECK.DATE,"DM"),'R%2'):FMT(OCONV(Y.CHECK.DATE,"DD"),'R%2'):Y.TEMP.TIME

    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.DATE.TIME>  = Y.DATE.TIME
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.CO.CODE>    = ID.COMPANY
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.DEPT.CODE>  = 1

    GOSUB WRITE.REDO.H.CUSTOMER.PROVISION

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
********************************
READ.REDO.H.CUSTOMER.PROVISION:
********************************
* In this para of the code, file REDO.H.CUSTOMER.PROVISION is read
    R.REDO.H.CUSTOMER.PROVISION  = ''
    REDO.H.CUSTOMER.PROVISION.ER = ''
    CALL F.READ(FN.REDO.H.CUSTOMER.PROVISION,REDO.H.CUSTOMER.PROVISION.ID,R.REDO.H.CUSTOMER.PROVISION,F.REDO.H.CUSTOMER.PROVISION,REDO.H.CUSTOMER.PROVISION.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
********************************
WRITE.REDO.H.CUSTOMER.PROVISION:
********************************

    CALL F.WRITE(FN.REDO.H.CUSTOMER.PROVISION,REDO.H.CUSTOMER.PROVISION.ID,R.REDO.H.CUSTOMER.PROVISION)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************

    APPL.ARRAY = 'MM.MONEY.MARKET'
    FLD.ARRAY  = "L.SC.PROV.CALC":@VM:"L.MM.OWN.PORT"
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.SC.PROV.CALC.POS = FLD.POS<1,1>
    LOC.L.MM.OWN.PORT.POS  = FLD.POS<1,2>

RETURN
*---------------------------------------------------------------------------------------------------------
END       ;* End of Program
