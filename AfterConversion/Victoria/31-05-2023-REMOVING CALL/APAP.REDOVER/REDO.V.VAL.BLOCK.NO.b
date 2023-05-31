* @ValidationCode : MjotMTgzMjE2NDk1MzpDcDEyNTI6MTY4NTUzNjAzNzEzMTp2aWN0bzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 17:57:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.BLOCK.NO
*
* ====================================================================================
*
*    - Gets the information related to the AA specified in input parameter
*
*    - Generates BULK OFS MESSAGES to apply payments to corresponding AA
*
* ====================================================================================
*
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose :
*
*
* Incoming:
* ---------
*
*
* Outgoing:

* ---------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for :
* Development by  :
* Date            :
*=======================================================================
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*13-04-2023       Conversion Tool        R22 Auto Code conversion          FM TO @FM,VM TO @VM
*13-04-2023       Samaran T               R22 Manual Code Conversion       Call Routine Format Modified
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.REDO.MAX.PRESTAR.VS
    $INSERT I_F.AA.ARRANGEMENT
*
*************************************************************************
*

    GOSUB INITIALISE

*    DEBUG

**** FOR VALIDATE INFORMATION OTHER COLLATERALS 06/09/2012***
    IF PGM.VERSION EQ ',REDO.INGRESO.OG' THEN
        IF Y.BLOCK.NO EQ '' THEN

            RETURN
        END
    END
**** END VALIDATE INFORMATION

    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

*
RETURN
*
* ======
PROCESS:
* ======

    IF Y.VALUE.DATE EQ '' THEN
        AF = COLL.VALUE.DATE
        ETEXT = "ST-NO.ING"
        CALL STORE.END.ERROR
    END

    Y.VALUE.YEAR = LEFT(Y.VALUE.DATE, 4)
    NUM.YEARS = Y.VALUE.YEAR - Y.BLOCK.NO

***IF THE USER SET THE CREDIT CODE ADD TO  CONDITION THE PRODUCT GROUP pdelarosa@temenos.com***

    VAR.CRED = R.NEW(COLL.LOCAL.REF)<1,WPOS.DIS.GARA>
    IF LEN(VAR.CRED) GT 0 THEN
        SEL.CRED  = 'SELECT ':FN.CRED
        SEL.CRED := ' WITH @ID EQ ' : VAR.CRED
        CALL EB.READLIST(SEL.CRED,SEL.LIST.CRED,'',NO.OF.REC.CRE,Y.ERR)

        IF NO.OF.REC.CRE GT 0 THEN
            REMOVE Y.CRED.ID FROM SEL.LIST.CRED SETTING Y.POS
            CALL F.READ(FN.CRED, Y.CRED.ID, R.CRED, F.CRED, Y.ERR.RMPV)
            VAR.CLASE = R.CRED<AA.ARR.PRODUCT.GROUP>
            VAR.COND  = ' AND PRODUCT.GROUP EQ ':VAR.CLASE
        END

    END
***END IF THE USER***

    IF NUM.YEARS EQ 0 THEN
        VAR.TIPO = " AND VEH.TYPE EQ 'NUEVO' "
    END

    IF NUM.YEARS GT 0 THEN
        VAR.TIPO = " AND VEH.TYPE EQ 'USADO' "
    END

    SEL.CMD  = 'SELECT ':FN.RMPV
    SEL.CMD := ' WITH VEH.USE.FROM LE ' : NUM.YEARS : ' AND VEH.USE.TO GE ': NUM.YEARS
    SEL.CMD  = SEL.CMD:VAR.COND:VAR.TIPO
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,Y.ERR)
    IF NO.OF.REC EQ 0 THEN
        AF = COLL.LOCAL.REF
        AV = YPOS<1,1>
        ETEXT = 'ST-PARAM.VH'
        CALL STORE.END.ERROR
    END

    REMOVE Y.RMPV.ID FROM SEL.LIST SETTING Y.POS

    CALL F.READ(FN.RMPV, Y.RMPV.ID, R.RMPV, F.RMPV, Y.ERR.RMPV)

    IF PGM.VERSION MATCHES '...REDO.MODIFICA...' THEN
        R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.PERC> = R.RMPV<R.MPV.PERC.MAX.AMT.LOAN>
        R.NEW(COLL.LOCAL.REF)<1,WPOS.COL.SECTOR> = R.RMPV<R.MPV.VEH.TYPE>
        R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.VALUE> = R.NEW(COLL.LOCAL.REF)<1,WPOS.TOT.VALUE> * (R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.PERC> / 100 )
    END ELSE
        R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.PERC> = R.RMPV<R.MPV.PERC.MAX.AMT.LOAN>
        R.NEW(COLL.LOCAL.REF)<1,WPOS.COL.SECTOR> = R.RMPV<R.MPV.VEH.TYPE>
        R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.VALUE> = R.NEW(COLL.LOCAL.REF)<1,WPOS.TOT.VALUE> * (R.RMPV<R.MPV.PERC.MAX.AMT.LOAN> / 100 )
    END

    R.NEW(COLL.LOCAL.REF)<1,WPOS.TOT.VALUE> = Y.NOMINAL.VALUE ;*** VALOR TOTAL TASACION
*  R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.VALUE> = R.NEW(COLL.LOCAL.REF)<1,WPOS.TOT.VALUE> * R.RMPV<R.MPV.PERC.MAX.AMT.LOAN> / 100


    IF R.NEW(COLL.EXECUTION.VALUE) EQ '' THEN
        R.NEW(COLL.EXECUTION.VALUE) = R.NEW(COLL.MAXIMUM.VALUE)
    END

*******************************************
*If the customer set a credit number
******************************************
*APAP.REDOVER.REDO.V.VAL.DISPO.COLL
    APAP.REDOVER.redoVValDispoColl()     ;*R22 MANUAL CODE CONVERSION
*****************************************

RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.RMPV, F.RMPV)
    CALL OPF(FN.CRED, F.CRED)
RETURN

*
* =========
INITIALISE:
* =========
*

    WCAMPO    = "L.COL.SEC.DESC"          ;*"L.COL.BLOCK.NO"
    WCAMPO<2> = "L.COL.SEC.REG" ;*"L.COL.SECTOR"
    WCAMPO<3> = "L.COL.LN.MX.PER"
    WCAMPO<4> = "L.COL.LN.MX.VAL"
    WCAMPO<5> = "L.COL.TOT.VALUA"
    WCAMPO<6> = "L.AC.LK.COL.ID"


    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)

    YPOS = ''

    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)

    WPOS.BLOCK.NO    = YPOS<1,1>
    WPOS.COL.SECTOR  = YPOS<1,2>
    WPOS.MAX.PERC    = YPOS<1,3>
    WPOS.MAX.VALUE   = YPOS<1,4>
    WPOS.TOT.VALUE   = YPOS<1,5>
    WPOS.DIS.GARA    = YPOS<1,6>

    Y.BLOCK.NO = COMI ;***R.NEW(COLL.LOCAL.REF)<1,WPOS.BLOCK.NO> ; *** ANIO FABRICACION
    Y.VALUE.DATE = R.NEW(COLL.VALUE.DATE) ;*** FECHA CREACION GARANTIA
    Y.COL.SECTOR = R.NEW(COLL.LOCAL.REF)<1,WPOS.COL.SECTOR>   ;*** NUEVO O USADO
    Y.NOMINAL.VALUE = R.NEW(COLL.NOMINAL.VALUE)     ;*** VALOR NOMINAL


    FN.RMPV = 'F.REDO.MAX.PRESTAR.VS'
    F.RMPV = ''
    R.RMPV = ''
    Y.RMPV.ID = ''
    Y.ERR.RMPV = ''

    FN.CRED   = 'F.AA.ARRANGEMENT'
    Y.CRED.ID = ''
    R.CRED    = ''
    F.CRED    = ''

    PROCESS.GOAHEAD = 1
    LOOP.CNT = 0
    MAX.LOOPS = 1

    SEL.CMD = ''
    SEL.LIST = ''
    NO.OF.REC = ''
    Y.ERR = ''

    VAR.COND =''
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1

                IF MESSAGE EQ 'VAL' THEN
                    PROCESS.GOAHEAD = ''
                END

        END CASE

        LOOP.CNT +=1
    REPEAT
*
RETURN
*

END
