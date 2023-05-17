*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.V.AUTH.FT.WV.COMTAX1
***********************************************************
*----------------------------------------------------------
*
* COMPANY NAME    : APAP
* DEVELOPED AT    : 13-08-2018
*
*----------------------------------------------------------
*
* DESCRIPTION     : AUTHORISATION routine to be used in FT versions
*                   Accounting of each COMM/TAX value in a separate debit
*------------------------------------------------------------
*
* Modification History :
*-----------------------
*  DATE             WHO             REFERENCE       DESCRIPTION
*
*----------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
*
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.COMPANY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.USER
    $INSERT I_F.BENEFICIARY

    PROCESS.GOHEAD='1'
*   CRT  R.NEW(FT.RECORD.STATUS)
    IF V$FUNCTION MATCHES "I"  OR V$FUNCTION EQ "A" AND R.NEW(FT.RECORD.STATUS) MATCHES "INAU":VM:"INAO" ELSE
        PROCESS.GOHEAD = ""
    END

    IF RUNNING.UNDER.BATCH THEN
        PROCESS.GOHEAD = '1'
    END

    IF PROCESS.GOHEAD THEN
        Y.STMT.NO       = R.NEW(FT.STMT.NOS)
        CALL EB.ACCOUNTING("AC","AUT",'','')
        Y.STMT.NO.NEW = R.NEW(FT.STMT.NOS)

        R.NEW(FT.STMT.NOS)       = Y.STMT.NO
        R.NEW(FT.STMT.NOS)<1,-1> = ID.COMPANY
        R.NEW(FT.STMT.NOS)<1,-1> = Y.STMT.NO.NEW

    END
    RETURN
END
