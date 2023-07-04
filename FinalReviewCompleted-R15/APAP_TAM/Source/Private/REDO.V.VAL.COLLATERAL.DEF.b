* @ValidationCode : Mjo0NjM5MjY1NTk6Q3AxMjUyOjE2ODQ0OTEwNDU3Nzk6SVRTUzotMTotMToxNzI6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 172
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.V.VAL.COLLATERAL.DEF
*
* ====================================================================================
*
* Default collateral fields.

* ====================================================================================
*
* Subroutine Type :Version routine
* Attached to     :
* Attached as     : Valdation routine
* Primary Purpose : defualt certain fields in COLLATERAL
*
*
* Incoming:
* ---------
*N.A
*
*
* Outgoing:

* ---------
*  N.A
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for :
* Development by  :
* Date            :
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.COLLATERAL
    $INSERT I_F.REDO.COLLATERAL.REA
*
*************************************************************************
    GOSUB INITIALISE
    GOSUB PROCESS

*
RETURN
*
* ======
PROCESS:
* ======
*Maximum Value
    ENCUM.VAL = R.NEW(COLL.LOCAL.REF)<1,ENCUM.VAL.POS>
    LN.MX.PER = R.NEW(COLL.LOCAL.REF)<1,LN.MX.PER.POS>
    TOT.VALUA = R.NEW(COLL.LOCAL.REF)<1,TOT.VALUA.POS>
    R.NEW(COLL.MAXIMUM.VALUE)   = (TOT.VALUA - ENCUM.VAL) * LN.MX.PER /100
    R.NEW(COLL.EXECUTION.VALUE) = R.NEW(COLL.MAXIMUM.VALUE)

*Genderal ledger value
    R.NEW(COLL.LOCAL.REF)<1,GEN.LED.POS> =R.NEW(COLL.NOMINAL.VALUE)

*Central bank value

    SEC.CLASSIFY = R.NEW(COLL.LOCAL.REF)<1,SEC.CLASS.POS>
    CALL F.READ(FN.REDO.COLLATERAL.REA,SEC.CLASSIFY,R.REDO.COLLATERAL.REA,F.REDO.COLLATERAL.REA,Y.ERR.REDO.COLLATERAL.REA)
    PERCENTAGE = R.REDO.COLLATERAL.REA<R.COL.REA.PERCENTAGE>
    Y.NOMINAL.VALUE = R.NEW(COLL.NOMINAL.VALUE)
    Y.CENTRAL.BANK.VALUE = Y.NOMINAL.VALUE * (PERCENTAGE/100)
    R.NEW(COLL.CENTRAL.BANK.VALUE) = Y.CENTRAL.BANK.VALUE

*VALOR TERRENO

    LAND.VAL = R.NEW(COLL.LOCAL.REF)<1,LAND.VAL.POS>
    LAND.AREA = R.NEW(COLL.LOCAL.REF)<1,LAND.AREA.POS>
    R.NEW(COLL.LOCAL.REF)<1,TO.LND.VA.POS> = LAND.VAL * LAND.AREA


*TOTAL VALOR CONSTRUCCION

    BLD.AREA = R.NEW(COLL.LOCAL.REF)<1,BLD.AREA.POS>
    BLD.VALUE = R.NEW(COLL.LOCAL.REF)<1,BLD.VALUE.POS>
    R.NEW(COLL.LOCAL.REF)<1,TOT.BD.AR.POS> = BLD.AREA * BLD.VALUE

* VALOR DEPRECIACION

    VAR.ANI.CON =  R.NEW(COLL.LOCAL.REF)<1,YR.BLDING.POS>
    VAR.POR.DEP = R.NEW(COLL.LOCAL.REF)<1,TOTAL.DEP.POS>
    VAR.TOT.CON = R.NEW(COLL.LOCAL.REF)<1,TOT.BD.AR.POS>
    VAR.VAL.DEP  = ((VAR.POR.DEP)/100)*VAR.TOT.CON*VAR.ANI.CON
    R.NEW(COLL.LOCAL.REF)<1,DEP.VALUE.POS> = VAR.VAL.DEP

* FECHA VENCIMIENTO TASACION

    VAL.DATE = R.NEW(COLL.LOCAL.REF)<1,VAL.DATE.POS>
    IF VAL.DATE THEN
        REVIEW.DT = R.NEW(COLL.LOCAL.REF)<1,REVIEW.DT.POS>
        DISPM = REVIEW.DT:'M'
        CALL CALENDAR.DAY(VAL.DATE,'+',DISPM)
        R.NEW(COLL.LOCAL.REF)<1,VA.DUE.DT.POS> = DISPM
    END

*TOTAL TASACION

*MACH.EQU.VAL    = R.NEW(COLL.LOCAL.REF)<1,MA.EQU.VAL.POS>
    VAR.TOT.LAN     = R.NEW(COLL.LOCAL.REF)<1,TO.LND.VA.POS>
    VAR.TOT.CON     = R.NEW(COLL.LOCAL.REF)<1,TOT.BD.AR.POS>
    VAR.VAL.DEP     = R.NEW(COLL.LOCAL.REF)<1,DEP.VALUE.POS>
    VAR.ADDED.VALUE = R.NEW(COLL.LOCAL.REF)<1,Y.ADDED.VAL.POS>
    VAR.VAL.TOT = VAR.TOT.LAN + VAR.TOT.CON - VAR.VAL.DEP
    VAR.VAL.TOT1 = VAR.VAL.TOT + VAR.ADDED.VALUE
    R.NEW(COLL.LOCAL.REF)<1,TOT.VALUA.POS> = VAR.VAL.TOT1

RETURN
*
* =========
INITIALISE:
* =========
    APPL.ARRAY='COLLATERAL'
    FLD.ARRAY='L.COL.ENCUM.VAL':@VM:'L.COL.LN.MX.PER':@VM:'L.COL.TOT.VALUA':@VM:'L.COL.GEN.LED':@VM:'L.COL.SEC.CLASS':@VM:'L.COL.LAND.VAL':@VM:'L.COL.LAND.AREA':@VM:'L.COL.TO.LND.VA':@VM:'L.COL.BLD.AREA':@VM:'L.COL.BLD.VALUE':@VM:'L.COL.TOT.BD.AR':@VM:'L.COL.YR.BLDING':@VM:'L.COL.TOTAL.DEP':@VM:'L.COL.DEP.VALUE':@VM:'L.COL.VAL.DATE':@VM:'L.COL.REVIEW.DT':@VM:'L.COL.VA.DUE.DT':@VM:'L.CO.MA.EQU.VAL':@VM:'L.AC.LK.COL.ID' ;*R22 AUTO CONVERSION
    FLD.POS=''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    ENCUM.VAL.POS = FLD.POS<1,1>
    LN.MX.PER.POS = FLD.POS<1,2>
    TOT.VALUA.POS = FLD.POS<1,3>
    GEN.LED.POS = FLD.POS<1,4>
    SEC.CLASS.POS = FLD.POS<1,5>
    LAND.VAL.POS =  FLD.POS<1,6>
    LAND.AREA.POS = FLD.POS<1,7>
    TO.LND.VA.POS = FLD.POS<1,8>
    BLD.AREA.POS =  FLD.POS<1,9>
    BLD.VALUE.POS = FLD.POS<1,10>
    TOT.BD.AR.POS = FLD.POS<1,11>
    YR.BLDING.POS = FLD.POS<1,12>
    TOTAL.DEP.POS = FLD.POS<1,13>
    DEP.VALUE.POS = FLD.POS<1,14>
    VAL.DATE.POS = FLD.POS<1,15>
    REVIEW.DT.POS = FLD.POS<1,16>
    VA.DUE.DT.POS = FLD.POS<1,17>
    MA.EQU.VAL.POS = FLD.POS<1,18>
    Y.ADDED.VAL.POS =  FLD.POS<1,19>

    FN.REDO.COLLATERAL.REA = 'F.REDO.COLLATERAL.REA'
    F.REDO.COLLATERAL.REA = ''
    R.REDO.COLLATERAL.REA = ''
    Y.ERR.REDO.COLLATERAL.REA = ''
    CALL OPF(FN.REDO.COLLATERAL.REA, F.REDO.COLLATERAL.REA)

RETURN

* ======================
END
