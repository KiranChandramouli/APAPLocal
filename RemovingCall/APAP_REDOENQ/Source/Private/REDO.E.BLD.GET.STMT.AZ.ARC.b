* @ValidationCode : MjoxNTAxNjMzNjk2OkNwMTI1MjoxNjgwNzcxMzE2MjE1OklUU1M6LTE6LTE6Mzc5OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 14:25:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 379
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.GET.STMT.AZ.ARC(Y.LIQ.ACCT,Y.AZ.STMT.ID.LIST)

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : PRABHU N
* Program Name  : REDO.E.BLD.VAL.ACCOUNT
*-------------------------------------------------------------------------
* Description: This routine is a build routine attached to all enquiries
* related to showing last five transactions
*----------------------------------------------------------
* Linked with: All enquiries with Customer no as selection field
* In parameter : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 09-09-2010         ODR-2010-08-0031                Routine for STMT.ENTRY
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - FM to @FM , SM to @SM and ++ to +=
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AZ.ACCOUNT

    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PGM.END

RETURN

*---------
OPENFILES:
*---------
*Tables required:ACCT.STMT.PRINT and STMT.PRINTED
*----------------------------------------------------------------------------------

    FN.ACCT.STMT.PRINT= 'F.ACCT.STMT.PRINT'
    F.ACCT.STMT.PRINT=''
    CALL OPF(FN.ACCT.STMT.PRINT,F.ACCT.STMT.PRINT)

    FN.STMT.PRINTED='F.STMT.PRINTED'
    F.STMT.PRINTED =''
    CALL OPF(FN.STMT.PRINTED,F.STMT.PRINTED)


RETURN

*-----------------------------------------
PROCESS:
*-----------------------------------------

    CALL F.READ(FN.ACCT.STMT.PRINT,Y.LIQ.ACCT,R.ACCT.STMT.PRINT,F.ACCT.STMT.PRINT,ERR)
    R.ACCT.STMT.PRINT.SIZE=DCOUNT(R.ACCT.STMT.PRINT,@FM)
    Y.CNT    =0
    Y.MAX.CNT=5
    IF R.ACCT.STMT.PRINT.SIZE LT 5 THEN
        Y.MAX.CNT =R.ACCT.STMT.PRINT.SIZE
    END
    LOOP
        Y.ACCT.STMT.POS=R.ACCT.STMT.PRINT.SIZE-Y.CNT
        CHANGE '/' TO @SM IN R.ACCT.STMT.PRINT
        R.ACCT.STMT.PRINT.LIST<-1>=R.ACCT.STMT.PRINT<Y.ACCT.STMT.POS,1,1>
        Y.CNT += 1
    WHILE  Y.CNT LT Y.MAX.CNT
    REPEAT


    Y.STMT.PRINT.CNT  = 1
    Y.STMT.PRINT.TOT  = DCOUNT(R.ACCT.STMT.PRINT.LIST,@FM)
    LOOP
    WHILE Y.STMT.PRINT.CNT LE Y.STMT.PRINT.TOT
        Y.STMT.PRINT.ID = R.ACCT.STMT.PRINT.LIST<Y.STMT.PRINT.CNT>
        Y.STMT.PRINT.LIST<-1>  = Y.LIQ.ACCT:'-':Y.STMT.PRINT.ID
        Y.STMT.PRINT.CNT += 1
    REPEAT



    LOOP
        REMOVE Y.STMT.PRINT.ID FROM Y.STMT.PRINT.LIST SETTING STMT.ENT.COS
    WHILE Y.STMT.PRINT.ID:STMT.ENT.COS
        CALL F.READ(FN.STMT.PRINTED,Y.STMT.PRINT.ID,R.STMT.PRINTED,F.STMT.PRINTED,ERR)
        Y.AZ.STMT.ID.LIST<-1>=R.STMT.PRINTED
        Y.TOT.STMT.ID.LIST = DCOUNT(Y.AZ.STMT.ID.LIST,@FM)
        IF Y.TOT.STMT.ID.LIST GE 5 THEN
            GOSUB PGM.END
        END
    REPEAT
RETURN
PGM.END:
END
