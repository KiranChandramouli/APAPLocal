* @ValidationCode : Mjo1MjA5OTgwMTQ6Q3AxMjUyOjE3MDM1MjA2MjQxNTI6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Dec 2023 21:40:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA


SUBROUTINE REDO.S.FC.AA.ST.CHG.DT(AA.ID, AA.ARR)

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose : To return value of AA.ARR.INTEREST>L.AA.REV.RT.TY  field
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
* AA.ARR - data returned to the routine
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            :
*
* Date             Who                   Reference      Description
* 30.03.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM, I TO I.VAR
* 30.03.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*22-12-2023	   VIGNESHWARI                       ADDED COMMENT FOR INTERFACE CHANGES- FIX SIT2 - By Santiago
*-----------------------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.BILL.DETAILS

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
    
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.ARRG.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,Y.ACT.DET.ERR)
    IF R.AA.ACCOUNT.DETAILS NE '' THEN
        Y.CONT = DCOUNT(R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>,@VM)    ;** R22 Auto conversion - VM TO @VM
        FOR I.VAR=Y.CONT TO 1 STEP -1         ;** R22 Auto conversion - I TO I.VAR
            BILL.REFERENCE = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,I.VAR>          ;** R22 Auto conversion - I TO I.VAR
            IF R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,I.VAR,1> EQ 'PAYMENT' AND R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS,I.VAR,1> EQ 'UNPAID' THEN       ;** R22 Auto conversion - I TO I.VAR
                CALL AA.GET.BILL.DETAILS(Y.ARRG.ID, BILL.REFERENCE, BILL.DETAILS, RET.ERROR)
                Y.PRE.DATE =  BILL.DETAILS<AA.BD.SET.ST.CHG.DT,1>   ;* 35
                Y.DIFF = "C"
                IF Y.PRE.DATE NE '' THEN	;*Fix FIX SIT2 � By Santiago-new lines added
                    CALL CDD("",Y.PRE.DATE,TODAY,Y.DIFF)
                    AA.ARR = Y.DIFF
                END ELSE	;*Fix FIX SIT2 � By Santiago-new lines added-start	
                    AA.ARR = ''
                END	;*Fix FIX SIT2 � By Santiago-new lines added-end
                BREAK
            END
        NEXT
    END

RETURN
*------------------------
INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    B.CONT = 0
    Y.ARRG.ID = AA.ID
    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS  = ''
    R.AA.ACCOUNT.DETAILS = ''
    AA.ARR = 'NULO'
RETURN

*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

RETURN
*------------
END
