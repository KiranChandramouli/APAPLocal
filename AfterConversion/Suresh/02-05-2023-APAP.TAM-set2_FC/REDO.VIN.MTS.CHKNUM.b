* @ValidationCode : MjoxMjE3MjU0ODg2OkNwMTI1MjoxNjgxODg0NTcyNjQ4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 11:39:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------
* <Rating>-65</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.VIN.MTS.CHKNUM
*
* =============================================================================
*
*    First Release : Victor Nava
*    Developed for : APAP
*    Developed by  : Nelson Salgado
*    Date          : 2011/Oct/31
*
* ======================================================================
*
*  PACS00146869 - Validates cheque number value according NV functionality
*  chain.
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
* ======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.TRANSACTION
*
    $INSERT I_F.REDO.TRANSACTION.CHAIN

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
*-------
PROCESS:
*-------
*
    IF Y.NO.CHQ NE "" THEN
        AF = TT.TE.LOCAL.REF
        AV = WPOSNC
        ETEXT = "TT-INP.NOT.ALLOW"
        CALL STORE.END.ERROR
        ETEXT = ""
    END
*
RETURN
*
* -----------
FIRST.NV.TXN:
* -----------
* L.TT.NO.OF.CHQ should be an optional input field.
* PACS00280731 - S
*    IF Y.NO.CHQ EQ "" AND Y.NV.FLD EQ "" THEN
*        AF = TT.TE.LOCAL.REF
*        AV = WPOSNC
*        ETEXT = "TT-INP.MISS"
*        CALL STORE.END.ERROR
*        ETEXT = ""
*    END
* PACS00280731 - E
*
    IF Y.NO.CHQ NE "" AND Y.NV.FLD NE "" THEN
        AF = TT.TE.LOCAL.REF
        AV = WPOSNC
        ETEXT = "TT-INP.NOT.ALLOW"
        CALL STORE.END.ERROR
        ETEXT = ""
    END
*
RETURN
* ---------
INITIALISE:
* ---------
    PROCESS.GOAHEAD    = 1
*
    FN.TELLER.TRANSACTION = "F.TELLER.TRANSACTION"
    F.TELLER.TRANSACTION  = ""
* PACS00245694 - S
    FN.REDO.TRANSACTION.CHAIN = "F.REDO.TRANSACTION.CHAIN"
    F.REDO.TRANSACTION.CHAIN  = ""
* PACS00245694 - E
    WAPP.LST = "TELLER"
    WCAMPO    = "L.INITIAL.ID"
    WCAMPO<2> = "L.NEXT.VERSION"
    WCAMPO<3> = "L.TT.NO.OF.CHQ"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    CALL MULTI.GET.LOC.REF(WAPP.LST,WCAMPO,YPOS)
    WPOSLI    = YPOS<1,1>
    WPOSNV    = YPOS<1,2>
    WPOSNC    = YPOS<1,3>

    WTTTX.ID             = ''
    R.TELLER.TRANSACTION = ''
    ERR.MSJ              = ''
    VAR.NUM              = ''
    Y.INI.ID             = ''
    Y.NO.CHQ             = ''
    Y.NV.FLD             = ''
*
RETURN

*
OPEN.FILES:
* ---------------
*
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP.CNT  = 1;    MAX.LOOPS = 2

*
* CAMBIOS DE CONDICION
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                WTTTX.ID = R.NEW(TT.TE.TRANSACTION.CODE)
                CALL F.READ(FN.TELLER.TRANSACTION,WTTTX.ID,R.TELLER.TRANSACTION,F.TELLER.TRANSACTION,ERR.MSJ)
                IF R.TELLER.TRANSACTION NE "" AND R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.1> NE '44' AND R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.2> NE '44' THEN
                    PROCESS.GOAHEAD    = "" ;*MANUAL R22 CODE CONVERSION
                    
                END

            CASE LOOP.CNT EQ 2
* PACS00245694 - S
                Y.NO.CHQ = R.NEW(TT.TE.LOCAL.REF)<1,WPOSNC>
                Y.NV.FLD = R.NEW(TT.TE.LOCAL.REF)<1,WPOSNV>
                CALL F.READ(FN.REDO.TRANSACTION.CHAIN,WINITIAL.ID,R.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN,ERR.MSJ)
                LOCATE ID.NEW IN R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID,1> SETTING Y.POS THEN
                    Y.INI.ID = R.NEW(TT.TE.LOCAL.REF)<1,WPOSLI>
                END ELSE
*        GOSUB FIRST.NV.TXN
                    PROCESS.GOAHEAD    = ""
                END
* PACS00245694 - E
        END CASE

        LOOP.CNT +=1
    REPEAT
*
RETURN
*
END
