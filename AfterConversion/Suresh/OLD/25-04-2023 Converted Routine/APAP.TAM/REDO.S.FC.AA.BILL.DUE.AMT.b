* @ValidationCode : MjotODAxNzE3MjkzOkNwMTI1MjoxNjgyNDIyMjE5MzU4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 17:00:19
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
SUBROUTINE REDO.S.FC.AA.BILL.DUE.AMT(AA.ID, AA.ARR)

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
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          VM TO @VM, I TO I.VAR, ++ TO +=
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
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
        Y.CONT = DCOUNT(R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>,@VM)
        I.VAR = 1 ;*AUTO R22 CODE CONVERSION
        LOOP
        WHILE I.VAR LE Y.CONT
            BILL.REFERENCE = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,I.VAR>
            IF R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,I.VAR,1> EQ 'PAYMENT' AND R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS,I.VAR,1> EQ 'UNPAID' THEN
                CALL AA.GET.BILL.DETAILS(Y.ARRG.ID, BILL.REFERENCE, BILL.DETAILS, RET.ERROR)
                LOCATE 'PRMORA' IN BILL.DETAILS<AA.BD.PROPERTY,1> SETTING Y.POS THEN
                    AA.ARR +=  SUM(BILL.DETAILS<AA.BD.OS.PROP.AMOUNT,Y.POS>)    ;* 35
                END
            END
            I.VAR += 1 ;*AUTO R22 CODE CONVERSION
        REPEAT
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
    AA.ARR = 0
    BILL.REFERENCE = ''
    BILL.DETAILS = ''
    RET.ERROR = ''
RETURN

*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

RETURN
*------------
END
