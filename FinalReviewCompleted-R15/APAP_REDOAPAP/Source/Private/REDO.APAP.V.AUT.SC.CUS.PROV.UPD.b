* @ValidationCode : MjotMTQyOTI4MDA5MTpDcDEyNTI6MTY4NDgzNjA1MzgyNjpJVFNTOi0xOi0xOjU0MzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 543
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.V.AUT.SC.CUS.PROV.UPD
*-------------------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : A.C.Rajkumar
* Program Name  : REDO.APAP.V.AUT.SC.CUS.PROV.UPD
* ODR NUMBER    : ODR-2010-09-0167
*-------------------------------------------------------------------------------------------------
* Description   : This is an authorisation routine attached to the VERSION - SEC.TRADE,APAP.BUY.OWN.BOOK
*                 and SEC.TRADE,APAP.SELL.OWN.BOOK, the routine updates the local file
*                 REDO.H.CUSTOMER.PROVISION with required values
* In parameter  : None
* out parameter : None
*--------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*   DATE             WHO            REFERENCE         DESCRIPTION
* 22-09-2010      A.C.Rajkumar   ODR-2010-09-0167   Initial Creation
* 26.05.2011           RIYAS                   PACS00061656                    Fix
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*18-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM , SM to @SM , TNO to C$T24.SESSION.NO, ++ to +=
*18-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



* -------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.USER
    $INSERT I_F.REDO.H.PROVISION.PARAMETER
    $INSERT I_F.REDO.H.CUSTOMER.PROVISION
*
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN

*--------------------------------------------------------------------------------------------------
OPEN.PARA:
*=========

    FN.SEC.TRADE = 'F.SEC.TRADE'
    F.SEC.TRADE  = ''
    CALL OPF(FN.SEC.TRADE, F.SEC.TRADE)

    FN.REDO.H.PROVISION.PARAMETER = 'F.REDO.H.PROVISION.PARAMETER'
    F.REDO.H.PROVISION.PARAMETER  = ''
    CALL OPF(FN.REDO.H.PROVISION.PARAMETER, F.REDO.H.PROVISION.PARAMETER)

    FN.REDO.H.CUSTOMER.PROVISION = 'F.REDO.H.CUSTOMER.PROVISION'
    F.REDO.H.CUSTOMER.PROVISION  = ''
    CALL OPF(FN.REDO.H.CUSTOMER.PROVISION, F.REDO.H.CUSTOMER.PROVISION)

    FN.SECURITY.MASTER = 'F.SECURITY.MASTER'
    F.SECURITY.MASTER  = ''
    CALL OPF(FN.SECURITY.MASTER, F.SECURITY.MASTER)

    Y.SC.NOM = ''
    Y.SC.INT = ''

RETURN

*---------------------------------------------------------------------------------------------------
PROCESS.PARA:
*============
    GOSUB CHECK.PROV.CALC
    IF NOT(Y.FLAG) THEN
        RETURN
    END
    GOSUB READ.PROVISION.PARAMETER
    GOSUB CHECK.CUSTOMER.PROVISION
    GOSUB UPDATE.SEC.TRANS.ID
    GOSUB UPDATE.AUDIT.FIELDS

RETURN

*---------------------------------------------------------------------------------------------------
CHECK.PROV.CALC:
*===============

    GOSUB FIND.MULTI.LOCAL.REF
    Y.CAL.POS=R.NEW(SC.SBS.LOCAL.REF)<1,LOC.L.SC.PROV.CALC.POS>
    IF Y.CAL.POS EQ 'YES' THEN
        Y.FLAG = 1
    END
RETURN

*---------------------------------------------------------------------------------------------------
READ.PROVISION.PARAMETER:
*========================

    REDO.H.PROVISION.PARAMETER.ID = 'SYSTEM'
*CALL F.READ(FN.REDO.H.PROVISION.PARAMETER, REDO.H.PROVISION.PARAMETER.ID, R.REDO.H.PROVISION.PARAMETER, F.REDO.H.PROVISION.PARAMETER, Y.ERR.REDO.H.PROVISION.PARAMETER)
* Tus start
    CALL CACHE.READ(FN.REDO.H.PROVISION.PARAMETER, REDO.H.PROVISION.PARAMETER.ID, R.REDO.H.PROVISION.PARAMETER,Y.ERR.REDO.H.PROVISION.PARAMETER)
* Tus end


RETURN

*----------------------------------------------------------------------------------------------------
CHECK.CUSTOMER.PROVISION:
*========================
    SECURITY.MASTER.ID = R.NEW(SC.SBS.SECURITY.CODE)
    CALL F.READ(FN.SECURITY.MASTER, SECURITY.MASTER.ID, R.SECURITY.MASTER, F.SECURITY.MASTER, Y.ERR.SECURITY.MASTER)
    IF R.SECURITY.MASTER THEN
        REDO.H.CUSTOMER.PROVISION.ID = R.SECURITY.MASTER<SC.SCM.ISSUER,1>
        CALL F.READ(FN.REDO.H.CUSTOMER.PROVISION, REDO.H.CUSTOMER.PROVISION.ID, R.REDO.H.CUSTOMER.PROVISION, F.REDO.H.CUSTOMER.PROVISION, Y.ERR.REDO.H.CUSTOMER.PROVISION)
        IF NOT(R.REDO.H.CUSTOMER.PROVISION) THEN
            GOSUB CREATE.CUSTOMER.PROVISION
        END ELSE
            GOSUB UPDATE.CUSTOMER.PROVISION
        END
    END

RETURN

*-----------------------------------------------------------------------------------------------------
CREATE.CUSTOMER.PROVISION:
*=========================
    Y.CUST.SEC.COUNT = DCOUNT(R.NEW(SC.SBS.CUST.SEC.ACC),@VM)
    Y.COUNT = 1
    LOOP
    WHILE Y.COUNT LE Y.CUST.SEC.COUNT
        Y.AF.POS = Y.COUNT
        Y.AV.POS = 1
        R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.PORTFOLIO.ID,Y.AF.POS>      = R.NEW(SC.SBS.CUST.SEC.ACC)<1,Y.AF.POS>
        R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SECURITY.NO,Y.AF.POS> = R.NEW(SC.SBS.SECURITY.CODE)
        GOSUB WRITE.CUS.PROV
        Y.COUNT += 1
    REPEAT

RETURN

*------------------------------------------------------------------------------------------------------
UPDATE.CUSTOMER.PROVISION:
*=========================

    Y.CUST.SEC.COUNT = DCOUNT(R.NEW(SC.SBS.CUST.SEC.ACC),@VM)
    Y.COUNT = 1
    LOOP
    WHILE Y.COUNT LE Y.CUST.SEC.COUNT
        Y.CUST.SEC.ACC=R.NEW(SC.SBS.CUST.SEC.ACC)<1,Y.COUNT>
        Y.PORTLFOLIO.ID=R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.PORTFOLIO.ID,1>
        LOCATE Y.CUST.SEC.ACC IN Y.PORTLFOLIO.ID SETTING Y.PORT.POS THEN
            GOSUB LOCATE.SECUTRITY.NO
        END ELSE
            GOSUB ADD.PORTFOLIO.DETAILS
        END
        Y.COUNT += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT

RETURN

*-------------------------------------------------------------------------------------------------------
LOCATE.SECUTRITY.NO:
*====================
    Y.SBS.SECURITY.CODE=R.NEW(SC.SBS.SECURITY.CODE)
    Y.PRO.SEC.NO=R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SECURITY.NO,Y.PORT.POS>
*  LOCATE Y.SBS.SECURITY.CODE IN Y.PRO.SEC.NO SETTING Y.SEC.POS THEN
*     GOSUB UPDATE.SECUTRITY.NO
*  END ELSE
    GOSUB ADD.SECURITY.DETAILS

RETURN

*--------------------------------------------------------------------------------------------------------
ADD.PORTFOLIO.DETAILS:
*=====================

    Y.PORT.COUNT = DCOUNT(R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.PORTFOLIO.ID>,@VM)
    Y.AF.POS = Y.PORT.COUNT + 1
    Y.AV.POS = 1
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.PORTFOLIO.ID,Y.AF.POS> =  R.NEW(SC.SBS.CUST.SEC.ACC)<1,Y.COUNT>
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SECURITY.NO,Y.AF.POS,Y.AV.POS> = R.NEW(SC.SBS.SECURITY.CODE)
    GOSUB WRITE.CUS.PROV

RETURN

*--------------------------------------------------------------------------------------------------------
UPDATE.SECUTRITY.NO:
*====================

    Y.AF.POS = Y.PORT.POS
*    Y.AV.POS = Y.SEC.POS
    GOSUB WRITE.CUS.PROV

RETURN

*-------------------------------------------------------------------------------------------------------
ADD.SECURITY.DETAILS:
*====================

    Y.SEC.COUNT = DCOUNT(R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SECURITY.NO,Y.PORT.POS>,@SM)
    Y.AF.POS = Y.PORT.POS
    Y.AV.POS = Y.SEC.COUNT + 1
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SECURITY.NO,Y.AF.POS,Y.AV.POS> = R.NEW(SC.SBS.SECURITY.CODE)
    GOSUB WRITE.CUS.PROV

RETURN

*--------------------------------------------------------------------------------------------------------
WRITE.CUS.PROV:
*==============

    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.PROV.DATE,Y.AF.POS,Y.AV.POS> = TODAY
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.PROV.TIME,Y.AF.POS,Y.AV.POS> = TIMEDATE()[1,8]
    Y.CUST.TRANS.CODE = R.NEW(SC.SBS.CUST.TRANS.CODE)<1,Y.COUNT>
*    Y.CUST.TRANS.CODES.TOT = R.NEW(SC.SBS.CUST.TRANS.CODE)
*    Y.COUNT.TRANS.CODE = DCOUNT(Y.CUST.TRANS.CODES.TOT,VM)
*    Y.CNT.CODE = 1
*    LOOP
*    WHILE Y.CNT.CODE LE Y.COUNT.TRANS.CODE
*        Y.CUST.TRANS.CODE = Y.CUST.TRANS.CODES.TOT<1,Y.CNT.CODE>
    GOSUB GET.SC.NOMINAL.INTEREST
*        Y.CNT.CODE ++
*    REPEAT
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.NOMINAL,Y.AF.POS,Y.AV.POS>  = Y.SC.NOMINAL + R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.NOMINAL,Y.AF.POS,Y.AV.POS>
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.INTEREST,Y.AF.POS,Y.AV.POS> = Y.SC.INTEREST + R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SC.INTEREST,Y.AF.POS,Y.AV.POS>

RETURN

*--------------------------------------------------------------------------------------------------------
GET.SC.NOMINAL.INTEREST:
*=======================

*    Y.PROV.DR.CODE = R.REDO.H.PROVISION.PARAMETER<PROV.SEC.DR.CODE>
*    Y.PROV.CR.CODE = R.REDO.H.PROVISION.PARAMETER<PROV.SEC.CR.CODE>
*
*    LOCATE Y.CUST.TRANS.CODE IN Y.PROV.CR.CODE SETTING Y.CR.POS THEN
*        Y.CUST.DR.NOM    = R.NEW(SC.SBS.CUST.NO.NOM)
*        Y.CUST.DR.INT    = R.NEW(SC.SBS.CUST.INTR.AMT)
*        Y.CNT.CUS.DR.NOM = DCOUNT(Y.CUST.DR.NOM,VM)
*        Y.CNT.CUS.DR.INT = DCOUNT(Y.CUST.DR.INT,VM)
*        Y.CNT.CUS.DR = 1
*        LOOP
*        WHILE Y.CNT.CUS.DR LE Y.CNT.CUS.DR.NOM
*            Y.CUS.DR.NOM.FIRST = Y.CUST.DR.NOM<1,Y.CNT.CUS.DR>
*            Y.CUS.DR.INT.FIRST = Y.CUST.DR.INT<1,Y.CNT.CUS.DR>
*            Y.SC.NOM + =  Y.CUS.DR.NOM.FIRST
*           Y.SC.INT + =  Y.CUS.DR.INT.FIRST
*            Y.SC.NOMINAL  = '-':ABS(Y.SC.NOM)
*            Y.SC.INTEREST = '-':ABS(Y.SC.INT)
*            Y.CNT.CUS.DR ++
*        REPEAT
*        Y.SC.NOMINAL  = '-':ABS(SUM(R.NEW(SC.SBS.CUST.NO.NOM,Y.COUNT)))
*        Y.SC.INTEREST = '-':ABS(R.NEW(SC.SBS.CUST.INTR.AMT,Y.COUNT))
*    END
*    LOCATE Y.CUST.TRANS.CODE IN Y.PROV.CR.CODE SETTING Y.CR.POS THEN
*        Y.SC.NOMINAL  = SUM(R.NEW(SC.SBS.CUST.NO.NOM,Y.COUNT))
*        Y.SC.INTEREST = R.NEW(SC.SBS.CUST.INTR.AMT,Y.COUNT)
* END


    Y.PRO.DR.CODE=R.REDO.H.PROVISION.PARAMETER<PROV.SEC.DR.CODE>
    Y.PRO.CR.CODE=R.REDO.H.PROVISION.PARAMETER<PROV.SEC.CR.CODE>
    CHANGE @VM TO @FM IN Y.PRO.DR.CODE
    CHANGE @VM TO @FM IN Y.PRO.CR.CODE
    LOCATE Y.CUST.TRANS.CODE IN Y.PRO.DR.CODE SETTING Y.DR.POS THEN
        Y.SC.NOMINAL  = '-':ABS(SUM(R.NEW(SC.SBS.CUST.NO.NOM)<1,Y.COUNT>))
        Y.SC.INTEREST = '-':ABS(R.NEW(SC.SBS.CUST.INTR.AMT)<1,Y.COUNT>)
    END

    LOCATE Y.CUST.TRANS.CODE IN Y.PRO.CR.CODE SETTING Y.CR.POS THEN
        Y.SC.NOMINAL  = SUM(R.NEW(SC.SBS.CUST.NO.NOM)<1,Y.COUNT>)
        Y.SC.INTEREST = R.NEW(SC.SBS.CUST.INTR.AMT)<1,Y.COUNT>
    END

RETURN

*--------------------------------------------------------------------------------------------------------
UPDATE.SEC.TRANS.ID:
*===================

    Y.TRANS.COUNT = DCOUNT(R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SEC.TRADE.ID>,@VM)
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.SEC.TRADE.ID,Y.TRANS.COUNT+1> = ID.NEW

RETURN

*--------------------------------------------------------------------------------------------------------
UPDATE.AUDIT.FIELDS:
*===================

    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CODE CONVERSON

    Y.TEMP.TIME = OCONV(TIME(),"MTS")
    Y.TEMP.TIME = Y.TEMP.TIME[1,5]
    CHANGE ':' TO '' IN Y.TEMP.TIME

    Y.CHECK.DATE = DATE()
    Y.DATE.TIME = OCONV(Y.CHECK.DATE,"DY2"):FMT(OCONV(Y.CHECK.DATE,"DM"),'R%2'):FMT(OCONV(Y.CHECK.DATE,"DD"),'R%2'):Y.TEMP.TIME

    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.DATE.TIME> = Y.DATE.TIME
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CODE CONVERSION
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.CO.CODE>   = ID.COMPANY
    R.REDO.H.CUSTOMER.PROVISION<CUS.PROV.DEPT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>

    CALL F.WRITE(FN.REDO.H.CUSTOMER.PROVISION, REDO.H.CUSTOMER.PROVISION.ID, R.REDO.H.CUSTOMER.PROVISION)

RETURN
*---------------------------------------------------------------------------------------------------------
FIND.MULTI.LOCAL.REF:
*====================

    APPL.ARRAY = 'SEC.TRADE'
    FLD.ARRAY  = 'L.SC.PROV.CALC'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.SC.PROV.CALC.POS = FLD.POS<1,1>

RETURN
*---------------------------------------------------------------------------------------------------------
END
