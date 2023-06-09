$PACKAGE APAP.TAM
SUBROUTINE REDO.TFR.S.CONSOL.KEY

* Subroutine Type : ROUTINE
* Attached to     : DAILY PROCESS
* Attached as     : ROUTINE
* Primary Purpose : GET DESC TO EACH ACCOUNT
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres- TAM Latin America
* Date            : 14 Feb 2011
*
*
*
*
** 17-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 17-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.RE.STAT.LINE.CONT
    $INSERT I_F.REDO.AZACC.DESC
    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS.MAIN
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS.MAIN:
*============

    SELECT.STATEMENT = 'SELECT ':FN.RE.STAT.LINE.CONT: ' WITH @ID LIKE MBGL...'

    RE.STAT.LINE.CONT = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    Y.STAT.LINE = ''
    CALL EB.READLIST(SELECT.STATEMENT,RE.STAT.LINE.CONT,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
    LOOP
        REMOVE Y.STAT.LINE FROM RE.STAT.LINE.CONT SETTING POS
    WHILE Y.STAT.LINE:POS


        CALL F.READ(FN.RE.STAT.LINE.CONT,Y.STAT.LINE,R.RE.STAT.LINE.CONT,F.RE.STAT.LINE.CONT,YERR)
        Y.ASST.CONSOL.KEY = R.RE.STAT.LINE.CONT<RE.SLC.ASST.CONSOL.KEY>
        Y.ASST.ASSET.TYPE = R.RE.STAT.LINE.CONT<RE.SLC.ASSET.TYPE>
        Y.ASST.DESC= R.RE.STAT.LINE.CONT<RE.SLC.DESC,1>



        GOSUB COSNLKEY.OOP
    REPEAT

RETURN

*------------------------
COSNLKEY.OOP:
*=========

    Y.I.CK = DCOUNT(Y.ASST.CONSOL.KEY,@VM)

    FOR X.I=1 TO Y.I.CK
        CUR.ASSET.TYPE =  Y.ASST.ASSET.TYPE<1,X.I>
        Y.ID.SEQU=Y.ASST.CONSOL.KEY<1,X.I>
        Y.ID.SEQU.AUX=FIELD(Y.ID.SEQU,'.',1)

        IF Y.ID.SEQU.AUX NE 'RE' THEN

            GOSUB CONTRACT.SEQU
        END

    NEXT X.I

RETURN


*------------------------
CONTRACT.SEQU:
*=========
    CALL F.READ(FN.RE.CONSOL.CONTRACT.SEQU,Y.ID.SEQU,R.RE.CONSOL.CONTRACT.SEQU,F.RE.CONSOL.CONTRACT.SEQU,YERR.SEQU)
    IF YERR.SEQU NE '' THEN
        Y.CONSOL.SEQU = DCOUNT(R.RE.CONSOL.CONTRACT.SEQU,@FM)

        FOR X.I.SE=1 TO Y.CONSOL.SEQU
            Y.ID.SEQU.CONTRAC=Y.ID.SEQU:';':R.RE.CONSOL.CONTRACT.SEQU<X.I.SE>

            GOSUB REA.CONTRACT.SEQU

        NEXT X.I.SE
    END

    Y.ID.SEQU.CONTRAC = Y.ID.SEQU
    GOSUB REA.CONTRACT.SEQU



RETURN

*------------------------
REA.CONTRACT.SEQU:
*=========

    CALL F.READ(FN.RE.CONSOL.CONTRACT,Y.ID.SEQU.CONTRAC,R.RE.CONSOL.CONTRACT,F.RE.CONSOL.CONTRACT,YERR.SEQ)
    Y.ACC.CONSOL.SEQU = DCOUNT(R.RE.CONSOL.CONTRACT,@FM)

    FOR X.I.ACC=1 TO Y.ACC.CONSOL.SEQU
        Y.AZ.ACC=R.RE.CONSOL.CONTRACT<X.I.ACC>

        GOSUB WRITE.AZ.DESC

    NEXT X.I.ACC

RETURN
*------------------------
WRITE.AZ.DESC:
*=========
*    R.REDO.AZACC.DESC = '' ; E.REDO.AZZ.DESC = ''
*    READ R.REDO.AZACC.DESC FROM F.REDO.AZACC.DESC,Y.AZ.ACC ELSE E.REDO.AZZ.DESC = 1
*
*    Y.READ.ERR = ''
*    R.REDO.AZACC.DESC = ''
*    CALL F.READ(FN.REDO.AZACC.DESC , Y.AZ.ACC, R.REDO.AZACC.DESC, F.REDO.AZACC.DESC, Y.READ.ERR)
*
*    IF E.REDO.AZZ.DESC THEN

    R.REDO.AZACC.DESC<AZACC.DESC> = Y.ASST.DESC
    R.REDO.AZACC.DESC<AZACC.ASSET.TYPE> = CUR.ASSET.TYPE

*    END ELSE
*        R.REDO.AZACC.DESC<AZACC.DESC,-1> = Y.ASST.DESC
*        R.REDO.AZACC.DESC<AZACC.ASSET.TYPE,-1> = CUR.ASSET.TYPE
*  END

    CALL F.WRITE(FN.REDO.AZACC.DESC,Y.AZ.ACC,R.REDO.AZACC.DESC)

RETURN


*------------------------
INITIALISE:
*=========

    FN.REDO.AZACC.DESC="F.REDO.AZACC.DESC"
    F.REDO.AZACC.DESC=""
    R.REDO.AZACC.DESC=""

    FN.RE.STAT.LINE.CONT="F.RE.STAT.LINE.CONT"
    F.RE.STAT.LINE.CONT=""
    R.RE.STAT.LINE.CONT=""

    FN.RE.CONSOL.CONTRACT="F.RE.CONSOL.CONTRACT"
    F.RE.CONSOL.CONTRACT=""
    R.RE.CONSOL.CONTRACT=""

    FN.RE.CONSOL.CONTRACT.SEQU="F.RE.CONSOL.CONTRACT.SEQU"
    F.RE.CONSOL.CONTRACT.SEQU=""
    R.RE.CONSOL.CONTRACT.SEQU=""
    X.I=''
    X.I.SE=''
    Y.ID.ASST.CONSOL.KEY=''
    Y.ASST.DESC=''

    Y.ACC.CONSOL.SEQU=''
    PROCESS.GOAHEAD = 1
    Y.ID.SEQU.AUX=''
RETURN
*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.RE.CONSOL.CONTRACT,F.RE.CONSOL.CONTRACT)
    CALL OPF(FN.RE.CONSOL.CONTRACT.SEQU,F.RE.CONSOL.CONTRACT.SEQU)
    CALL OPF(FN.RE.STAT.LINE.CONT,F.RE.STAT.LINE.CONT)
    CALL OPF(FN.REDO.AZACC.DESC,F.REDO.AZACC.DESC)
RETURN
*------------
END
