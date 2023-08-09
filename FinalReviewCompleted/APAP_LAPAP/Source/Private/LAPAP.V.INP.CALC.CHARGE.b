* @ValidationCode : MjoxMzA3OTc1NzE0OkNwMTI1MjoxNjkwMTY3NTUzNTkyOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP

SUBROUTINE LAPAP.V.INP.CALC.CHARGE

*--------------------------------------------------------------------------------
*Company   Name    : Asociacion Popular de Ahorros y Prestamos
*Developed By      : GANESH.R
*Program   Name    : REDO.V.INP.CALC.CHARGE
*Reference         : ODR-2009-10-0424
*HD Issue No       : HD1037932
*---------------------------------------------------------------------------------

*DESCRIPTION       :THIS PROGRAM IS USED TO CALCULATE COMMISSION CHARGES FOR
*                   CUSTOMER DURING CLOSE OF ACCOUNT
*Modification on 20 Jan 2011 : Reduced the Code Rating
*Modification on 02 Jun 2022 : Use FBNK.IC.LAPAP.CLO.CHARGE.PARAM as source for ...
*                              ... Charge parameter for PERSONA JURIDICA.
* ----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE		 AUTHOR				    Modification                           DESCRIPTION
*13/07/2023	VIGNESHWARI	MANUAL    R22 CODE CONVERSION               NOCHANGE
*13/07/2023	CONVERSION TOOL       AUTO R22 CODE CONVERSION	        T24.BP,BP is removed in insertfile, VM changed to @VM,FM changed to @FM,SM changed to @SM,
*									                                "=" changed to "EQ",'F.READ' changed to 'CACHE.READ',CONVERT changed to CHANGE
*-----------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.IC.LAPAP.CLO.CHARGE.PARAM


    IF MESSAGE EQ '' THEN
        GOSUB INIT
        GOSUB OPEN.FILES
        GOSUB PROCESS
    END
RETURN

*------------------------------------------------------------------------------
*DESCRIPTION : Initialising the variables
*------------------------------------------------------------------------------
INIT:

    VAL=''
    FT4.L.FT4.LRF.CCY=''
    ACL.CLO.CHARGE.AMT=''
    FT4.LRF.CCY=''
    ACL.CURRENCY=''

    LOC.REF.APPLICATION="FT.COMMISSION.TYPE":@FM:"ACCOUNT.CLOSURE":@FM:"CUSTOMER"
    LOC.REF.FIELDS='L.FT4.LRF.CCY':@VM:'L.FT4.MIN.PER':@VM:'L.FT4.CLO.CHG':@FM:'L.ACL.WAIVE.CHG':@FM:'L.CU.TIPO.CL':@VM:'L.CU.SEGMENTO'
    LOC.REF.POS=''

RETURN

*------------------------------------------------------------------------------
*DESCRIPTION: Opening the files ACCOUNT, FT.COMMISSION.TYPE and ACCOUNT.CLOSURE
*------------------------------------------------------------------------------
OPEN.FILES:

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.FT.COMMISSION.TYPE='F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE=''
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)

    FN.ACCOUNT.CLOSURE='F.ACCOUNT.CLOSURE'
    F.ACCOUNT.CLOSURE=''
    CALL OPF(FN.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE)

    FN.IC.LAPAP.CLO.CHARGE.PARAM = 'F.IC.LAPAP.CLO.CHARGE.PARAM'
    F.IC.LAPAP.CLO.CHARGE.PARAM = ''
    CALL OPF(FN.IC.LAPAP.CLO.CHARGE.PARAM,F.IC.LAPAP.CLO.CHARGE.PARAM)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN

*--------------------------------------------------------------------------------
*DESCRIPTION:Getting the position of the local fields from FT.COMMISSION
*             ACCOUNT.CLOSURE applications
*--------------------------------------------------------------------------------
PROCESS:
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    LOC.LRF.CCY=LOC.REF.POS<1,1>
    LOC.MIN.HOLD.PERIOD=LOC.REF.POS<1,2>
    LOC.EARLY.CLOSE.CHARGE=LOC.REF.POS<1,3>
    LOC.WAIVE.CHARGES=LOC.REF.POS<2,1>
    LOC.L.CU.TIPO.CL=LOC.REF.POS<3,1>
    LOC.L.CU.SEGMENTO=LOC.REF.POS<3,2>

*---------------------------------------------------------------------------------
*DESCRIPTION:Calculation of Charges
*---------------------------------------------------------------------------------

    ACCOUNT.ID=ID.NEW
    WAIVE.CHG=R.NEW(AC.ACL.LOCAL.REF)<1,LOC.WAIVE.CHARGES>
    ACCT.CLO.CURRENCY=R.NEW(AC.ACL.CURRENCY)
*Check for Waiver

    IF WAIVE.CHG EQ 'Y' THEN
        R.NEW(AC.ACL.CLO.CHARGE.AMT)=0
        CURR.NO = DCOUNT(R.NEW(AC.ACL.OVERRIDE),@VM) + 1
        TEXT='AC.CLOSE.WAIVE.CHGS'
        CALL STORE.OVERRIDE(CURR.NO)
    END

    IF WAIVE.CHG EQ '' THEN
        R.ACCOUNT =''
        CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ERR)
        START.DATE=R.ACCOUNT<AC.OPENING.DATE>
        END.DATE = TODAY
        NO.OF.MONTHS = ''
        CALL EB.NO.OF.MONTHS(START.DATE,END.DATE,NO.OF.MONTHS)
        Y.CUSTOMER.NUMBER = R.ACCOUNT<AC.CUSTOMER>
        Y.ACC.CATEGORY =  R.ACCOUNT<AC.CATEGORY>

        CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.NUMBER,R.CUSTOMER,F.CUSTOMER,ERR.CUSTOMER)
        Y.CUSTOMER.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF><1,LOC.L.CU.TIPO.CL>
        Y.CUSTOMER.SEGMENT = R.CUSTOMER<EB.CUS.LOCAL.REF><1,LOC.L.CU.SEGMENTO>

        FTID=R.NEW(AC.ACL.CLO.CHARGE.TYPE)
        R.FT.COMMISSION.TYPE=''

        CALL CACHE.READ(FN.FT.COMMISSION.TYPE, FTID, R.FT.COMMISSION.TYPE, ERR) ;*AUTO R22 CODE CONVERSION
        LOC.CURR=R.FT.COMMISSION.TYPE<FT4.LOCAL.REF><1,LOC.LRF.CCY>

        CHANGE @SM TO @FM IN LOC.CURR ;*AUTO R22 CODE CONVERSION

        CALL F.READ(FN.IC.LAPAP.CLO.CHARGE.PARAM,FTID,R.IC.LAPAP.CLO.CHARGE.PARAM,F.IC.LAPAP.CLO.CHARGE.PARAM,ERR.IC)

        IF R.IC.LAPAP.CLO.CHARGE.PARAM NE '' AND Y.CUSTOMER.TYPE EQ 'PERSONA JURIDICA' THEN
            GOSUB CALC.CHARGE.FROM.PARAMS
        END ELSE
            LOCATE ACCT.CLO.CURRENCY IN LOC.CURR<1> SETTING POS THEN
                GOSUB CALC.CHARGE
            END
        END


    END
RETURN

**************
CALC.CHARGE:
**************
*Applying Charges

    CLOSE.CHG=R.FT.COMMISSION.TYPE<FT4.LOCAL.REF><1,LOC.EARLY.CLOSE.CHARGE,POS>
    MINIMUM.HOLD=R.FT.COMMISSION.TYPE<FT4.LOCAL.REF><1,LOC.MIN.HOLD.PERIOD,POS>
    IF MINIMUM.HOLD[1] EQ 'Y' THEN ;*AUTO R22 CODE CONVERSION
        VAL=FIELD(MINIMUM.HOLD,'Y',1)
        MIN.HOLD.VALUE=VAL * 12
    END
    ELSE
        IF MINIMUM.HOLD[1] EQ 'M' THEN
            VAL=FIELD(MINIMUM.HOLD,'M',1)
            MIN.HOLD.VALUE=VAL
        END
    END

    IF NO.OF.MONTHS LT MIN.HOLD.VALUE  THEN
        R.NEW(AC.ACL.CLO.CHARGE.AMT)=CLOSE.CHG
        CURR.NO = DCOUNT(R.NEW(AC.ACL.OVERRIDE),@VM) + 1
        TEXT='AC.CLOSE.CHG.AMT'
        CALL STORE.OVERRIDE(CURR.NO)
    END

RETURN

****************
CALC.CHARGE.FROM.PARAMS:
****************
    MSG<-1> = 'NO OF MONTHS= ' : NO.OF.MONTHS
*CALL LAPAP.LOGGER('LOGGER.BP',ID.NEW,MSG)
*NO.OF.MONTHS = 7;*--> For test purpose.

    IF NO.OF.MONTHS GT 12 THEN
        RETURN
    END

    P.WAIVE.CATEGORY = R.IC.LAPAP.CLO.CHARGE.PARAM<IC.LAP86.WAIV.CATEGORIES>

    FINDSTR Y.ACC.CATEGORY IN P.WAIVE.CATEGORY SETTING v.fieldNo, v.valueNo THEN
*If we enter here the account category is amongst waive ones.
        R.NEW(AC.ACL.CLO.CHARGE.AMT)=0
        CURR.NO = DCOUNT(R.NEW(AC.ACL.OVERRIDE),@VM) + 1
        TEXT='AC.CLOSE.WAIVE.CHGS'
        CALL STORE.OVERRIDE(CURR.NO)

        RETURN
    END

    Y.PERIOD.FLAG = ''
    IF NO.OF.MONTHS LE 1 THEN
        Y.PERIOD.FLAG = '1M'
    END
    IF NO.OF.MONTHS GT 1 AND NO.OF.MONTHS LE 12 THEN
        Y.PERIOD.FLAG = '12M'
    END
    P.SEGMENTOS = R.IC.LAPAP.CLO.CHARGE.PARAM<IC.LAP86.CUS.SEGMENT>


    FINDSTR Y.CUSTOMER.SEGMENT IN P.SEGMENTOS SETTING v.Fld, v.Val THEN
        CRT "Field : " : v.Fld, "Position : " : v.Val
        P.PERIODOS = R.IC.LAPAP.CLO.CHARGE.PARAM<IC.LAP86.CLO.PERIOD,v.Val>
        CHANGE @SM TO @VM IN P.PERIODOS
        FINDSTR Y.PERIOD.FLAG IN P.PERIODOS SETTING v.Fld2, v.Val2 THEN
            CRT "Field : " : v.Fld2, "Position : " : v.Val2
            Y.CHG.AMT = R.IC.LAPAP.CLO.CHARGE.PARAM<IC.LAP86.PERIOD.AMT,v.Val,v.Val2>
            CRT "Amount to charge: " : Y.CHG.AMT
*DEBUG
        END ELSE
            CRT "Period not found"
            Y.CHG.AMT = R.IC.LAPAP.CLO.CHARGE.PARAM<IC.LAP86.DEFAULT.CHG.AMT>
        END
    END ELSE
        CRT "Segment not found"
        Y.CHG.AMT = R.IC.LAPAP.CLO.CHARGE.PARAM<IC.LAP86.DEFAULT.CHG.AMT>
    END

    MSG<-1> = ''
    MSG<-1> = 'Y.CUSTOMER.SEGMENT= ': Y.CUSTOMER.SEGMENT
    MSG<-1> = 'Y.PERIOD.FLAG= ': Y.PERIOD.FLAG
    MSG<-1> = 'Y.CHG.AMT= ': Y.CHG.AMT
*CALL LAPAP.LOGGER('LOGGER.BP',ID.NEW,MSG)
*DEBUG
    R.NEW(AC.ACL.CLO.CHARGE.AMT)= Y.CHG.AMT
    CURR.NO = DCOUNT(R.NEW(AC.ACL.OVERRIDE),@VM) + 1
    TEXT='AC.CLOSE.CHG.AMT'
    CALL STORE.OVERRIDE(CURR.NO)
RETURN

END
