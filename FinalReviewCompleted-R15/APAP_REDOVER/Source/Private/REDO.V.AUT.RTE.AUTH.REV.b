* @ValidationCode : Mjo0NzEwNDUzNzQ6Q3AxMjUyOjE2ODI0MTIzMzYxMzk6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUT.RTE.AUTH.REV
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.V.AUT.RTE.AUTH.REV
* ODR NUMBER    : ODR-2009-10-0472
*-------------------------------------------------------------------------

* Description : This routine is used to fetch the Ids of FT,Teller for the No file Enquiry REDO.INAO.RTE.TXNS

* In parameter : None
* out parameter : None

*----------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*10-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*10-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------
 
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER

    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

OPEN.FILES:

*Opening Files
    FN.REDO.FT.TT.REV = 'F.REDO.FT.TT.REV'
    F.REDO.FT.TT.REV = ''
    CALL OPF(FN.REDO.FT.TT.REV,F.REDO.FT.TT.REV)
RETURN

PROCESS:

*Writing the ID's to the Template

    VAR.CHK.APPLN=APPLICATION
    IF VAR.CHK.APPLN EQ 'FUNDS.TRANSFER' THEN
        VAR.REC.STAT=R.NEW(FT.RECORD.STATUS)
    END
    IF VAR.CHK.APPLN EQ 'TELLER' THEN
        VAR.REC.STAT=R.NEW(TT.TE.RECORD.STATUS)
    END
    IF VAR.REC.STAT EQ 'REVE' THEN
        REV.TXN.ID = ID.NEW
        REV.TXN.ARR = ''

*    WRITE REV.TXN.ARR ON F.REDO.FT.TT.REV,REV.TXN.ID ;*Tus Start
        CALL F.WRITE(FN.REDO.FT.TT.REV,REV.TXN.ID,REV.TXN.ARR);*Tus End
        IF NOT(RUNNING.UNDER.BATCH) AND NOT(PGM.VERSION) THEN
            CALL JOURNAL.UPDATE('')
        END
        REV.TXN.ID = ''
    END

RETURN
END
