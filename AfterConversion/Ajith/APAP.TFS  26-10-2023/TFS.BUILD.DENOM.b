* @ValidationCode : MjoxNTQ4NjIxNzY3OkNwMTI1MjoxNjk4MzA2OTk0MDk2OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Oct 2023 13:26:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>148</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TFS.BUILD.DENOM
*
* Subroutine to build Denomination details in an array. This will be done
* in a way similar to TELLER.
*
*-------------------------------------------------------------------------------
*
* Modification History:
*
* 03/03/05 - Sathish PS
*            New Development
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Ajithkumar             R22 Manual Conversion                GLOBUS.BP,USPLATFORM.BP FILE  REMOVED,VM,FM tO @VM ,@FM
*
*-------------------------------------------------------------------------------
    $INCLUDE I_COMMON    ;*R22 Manual Conversion-Start
    $INCLUDE I_EQUATE
    $INCLUDE I_F.TELLER.DENOMINATION
    $INCLUDE I_F.TELLER

    $INCLUDE I_T24.FS.COMMON ;*R22 Manual Conversion-End

    GOSUB INIT
    GOSUB PRELIM.CONDS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
    IF E THEN
        GOSUB CLEAR.CACHE
    END

RETURN
*-------------------------------------------------------------------------------
PROCESS:

    CALL CACHE.READ(FN.TD,'SSelectIDs',TD.ID.LIST,ERR.TD)
    IF TD.ID.LIST THEN

        LOOP
            REMOVE ID.TD FROM TD.ID.LIST SETTING MORE.IDS
        WHILE ID.TD : MORE.IDS DO

            CALL CACHE.READ(FN.TD,ID.TD,R.TD,ERR.TD)
            IF ERR.TD THEN
                E = 'EB-TFS.REC.MISS.FILE' :@FM: ID.TD :@VM: FN.TD
            END ELSE
                DENOM.CCY = ID.TD[1,3]
                DENOM.VALUE = R.TD<TT.DEN.VALUE>
                IF DENOM.CCY MATCHES TFS$CCY.LIST THEN
                    GOSUB APPEND.TO.CACHE
                END ELSE
                    E = 'EB-TFS.INVALID.CCY' :@FM: DENOM.CCY
                END
            END

        REPEAT
    END ELSE
        E = 'EB-TFS.NO.RECS.IN.TELLER.DENOM' :@FM: FN.TD
    END

RETURN
*-------------------------------------------------------------------------------
APPEND.TO.CACHE:

    LOCATE DENOM.CCY IN TFS$TT.DENOM.CCY<1> SETTING CCY.POS ELSE
        TFS$TT.DENOM.CCY<CCY.POS> = DENOM.CCY
    END
*
    LOCATE DENOM.VALUE IN TFS$TT.DENOM(CCY.POS)<2,1> BY 'DR' SETTING VALUE.POS ELSE
        INS ID.TD BEFORE TFS$TT.DENOM(CCY.POS)<1,VALUE.POS>
        INS DENOM.VALUE BEFORE TFS$TT.DENOM(CCY.POS)<2,VALUE.POS>
    END

RETURN
*-------------------------------------------------------------------------------
CLEAR.CACHE:

    TFS$TT.DENOM.CCY = ''
    MAT TFS$TT.DENOM = ''

RETURN
*-------------------------------------------------------------------------------
*//////////////////////////////////////////////////////////////////////////////*
*//////////////////P R E  P R O C E S S  S U B R O U T I N E S ////////////////*
*//////////////////////////////////////////////////////////////////////////////*
INIT:

    PROCESS.GOAHEAD = 1
    IF UNASSIGNED(TFS$TT.DENOM.CCY) THEN
        TFS$TT.DENOM.CCY = ''
        MAT TFS$TT.DENOM = ''
    END
*
    FN.TD = 'F.TELLER.DENOMINATION' ; F.TD = ''

RETURN
*-------------------------------------------------------------------------------
PRELIM.CONDS:

    IF TFS$TT.DENOM.CCY THEN PROCESS.GOAHEAD = 0

RETURN
*-------------------------------------------------------------------------------
END
