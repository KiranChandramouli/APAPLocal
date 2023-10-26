* @ValidationCode : MjotMzk5OTQxNjQ5OkNwMTI1MjoxNjk4MzA4MjIzMjI3OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Oct 2023 13:47:03
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
* <Rating>9</Rating>
*-----------------------------------------------------------------------------

*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Ajithkumar             R22 Manual Conversion                GLOBUS.BP File is Removed
*
SUBROUTINE TFS.GET.OPEN.TILL(TILL.ID)
*
* Subroutine Type : PROCEDURE
* Attached to     : N/A
* Attached as     : N/A
* Primary Purpose : Gets the TELLER.ID which is OPEN for the OPERATOR
*
* Incoming:
* ---------
* NONE
*
* Outgoing:
* ---------
* TILL.ID
*
* Error Variables:
* ----------------
* E - Related Error Messages
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* 27 Aug 2007 - Ganesh Prasad K
*
*-----------------------------------------------------------------------------------
    $INCLUDE  I_COMMON
    $INCLUDE  I_EQUATE

    $INCLUDE  I_GTS.COMMON
    $INCLUDE  I_F.TELLER.ID

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN
*-----------------------------------------------------------------------------------
PROCESS:

    R.TELLER.USER = '' ; ER.TELLER.USER = ''
    CALL F.READ(FN.TELLER.USER,TELLER.USER.ID,R.TELLER.USER,F.TELLER.USER,ER.TELLER.USER)
    IF NOT(ER.TELLER.USER) THEN
        TOT.TID = DCOUNT(R.TELLER.USER,@FM)
        FOR XX = 1 TO TOT.TID
            TELLER.ID = R.TELLER.USER<XX>
            R.TELLER.ID = '' ; ER.TELLER.ID = '' ; TT.STATUS = ''
            CALL F.READ(FN.TELLER.ID,TELLER.ID,R.TELLER.ID,F.TELLER.ID,ER.TELLER.ID)
            IF NOT(ER.TELLER.ID) THEN
                TI.STATUS = R.TELLER.ID<TT.TID.STATUS>
                IF TI.STATUS EQ 'OPEN' THEN
                    TILL.ID = TELLER.ID
                    BREAK
                END
            END ELSE
                E = 'EB-US.REC.MISS.FILE'
                E<2,1> = TELLER.ID
                E<2,2> = FN.TELLER.ID
            END
        NEXT XX
    END ELSE
        E = 'EB-US.REC.MISS.FILE'
        E<2,1> = TELLER.USER.ID
        E<2,2> = FN.TELLER.USER
    END

RETURN
*-----------------------------------------------------------------------------------
*//////////////////////////////////////////////////////////////////////////////////*
*////////////////P R E  P R O C E S S  S U B R O U T I N E S //////////////////////*
*//////////////////////////////////////////////////////////////////////////////////*
INITIALISE:

    PROCESS.GOAHEAD = 1

    TELLER.USER.ID = OPERATOR ; TILL.ID = ''

RETURN
*-----------------------------------------------------------------------------------
OPEN.FILES:

    FN.TELLER.USER = 'F.TELLER.USER'
    CALL OPF(FN.TELLER.USER,F.TELLER.USER)

    FN.TELLER.ID = 'F.TELLER.ID'
    CALL OPF(FN.TELLER.ID, F.TELLER.ID)

RETURN
*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*
    LOOP.CNT = 1 ; MAX.LOOPS = 0
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO

        BEGIN CASE
            CASE LOOP.CNT EQ 1
        END CASE
        LOOP.CNT += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------------
END

