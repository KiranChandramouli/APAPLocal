* @ValidationCode : MjoxNzA3MTg4Mjk6Q3AxMjUyOjE2ODI0MTIzMzYwNjM6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
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
SUBROUTINE REDO.V.AUT.REV.TXN
***********************************************************
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : R Ganesh
* PROGRAM NAME : REDO.V.AUT.REV.TXN
* Reference Number:ODR-2009-10-0472
* Date         : 12-2-2010
*----------------------------------------------------------
* DESCRIPTION : This Auth routine is used for storing the IDs of the transaction in a concat File
*------------------------------------------------------------
*    IN PARAMETER: NONE
*    OUT PARAMETER: NONE
*-----------------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*-----------------------------------------------------------------------------------------------
* NAME                 REFERENCE            DATE       DESCRIPTION
* SUDHARSANAN S      PACS00023990        28-04-2011  Storing Reversal ID's for COB Process
* *----------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                   DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion          FM TO @FM
*10-04-2023              Samaran T                R22 Manual Code conversion         No Changes
*----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
********
INIT:
*********
    LRF.APP='TELLER':@FM:'FUNDS.TRANSFER'
    LRF.FIELD='L.RTE.FORM':@FM:'L.RTE.FORM'
    LRF.POS=''
RETURN
************
OPEN.FILES:
*************
*Opening Files
    FN.REDO.FT.TT.REV='F.REDO.FT.TT.REV'
    F.REDO.FT.TT.REV=''
    CALL OPF(FN.REDO.FT.TT.REV,F.REDO.FT.TT.REV)
*PACS00023990 -S
    FN.REDO.FT.TT.REV.REC = 'F.REDO.FT.TT.REV.REC'
    F.REDO.FT.TT.REV.REC = ''
    CALL OPF(FN.REDO.FT.TT.REV.REC,F.REDO.FT.TT.REV.REC)
*PACS00023990 - E
RETURN
********
PROCESS:
********
*Checking for the application
    CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)
    LOC.TT.RTE.POS=LRF.POS<1,1>
    LOC.FT.RTE.POS=LRF.POS<2,1>
    VAR.TXN.ID=ID.NEW
    VAR.APPLN=APPLICATION
    IF VAR.APPLN EQ 'TELLER' THEN
        VAR.REC.STATUS=R.NEW(TT.TE.RECORD.STATUS)
        VAR.RTE.FORM=R.NEW(TT.TE.LOCAL.REF)<1,LOC.TT.RTE.POS>
        IF VAR.REC.STATUS[1,2] EQ 'RN' AND VAR.RTE.FORM EQ 'YES' THEN
            GOSUB TELLER.PROCESS
        END
    END
    IF VAR.APPLN EQ 'FUNDS.TRANSFER' THEN
        VAR.REC.STATUS=R.NEW(FT.RECORD.STATUS)
        VAR.RTE.FORM=R.NEW(FT.LOCAL.REF)<1,LOC.FT.RTE.POS>
        IF VAR.REC.STATUS[1,2] EQ 'RN' AND VAR.RTE.FORM EQ 'YES' THEN
            GOSUB FT.PROCESS
        END
    END
RETURN
****************
TELLER.PROCESS:
****************
*Writing the IDs to the File
    VAR.CURR.NO=R.NEW(TT.TE.CURR.NO)
    TXN.REV.ID=VAR.CURR.NO+1
    CONCAT.ID=VAR.TXN.ID:';':VAR.CURR.NO
    CALL F.READ(FN.REDO.FT.TT.REV,CONCAT.ID,R.REDO.FT.TT.REV,F.REDO.FT.TT.REV,CONCAT.ERR)
    CALL F.WRITE(FN.REDO.FT.TT.REV,CONCAT.ID,R.REDO.FT.TT.REV)
*PACS00023990 - S
    CALL F.READ(FN.REDO.FT.TT.REV.REC,TODAY,R.REDO.FT.TT.REV.REC,F.REDO.FT.TT.REV.REC,REV.ERR)
    IF R.REDO.FT.TT.REV.REC THEN
        R.REDO.FT.TT.REV.REC<-1> = VAR.TXN.ID
    END ELSE
        R.REDO.FT.TT.REV.REC = VAR.TXN.ID
    END
    CALL F.WRITE(FN.REDO.FT.TT.REV.REC,TODAY,R.REDO.FT.TT.REV.REC)
*PACS00023990 -E
RETURN
****************
FT.PROCESS:
****************
*Writing the IDs to the Concat File
    VAR.CURR.NO=R.NEW(FT.CURR.NO)
    TXN.REV.ID=VAR.CURR.NO+1
    CONCAT.ID=VAR.TXN.ID:';':VAR.CURR.NO
    CALL F.READ(FN.REDO.FT.TT.REV,CONCAT.ID,R.REDO.FT.TT.REV,F.REDO.FT.TT.REV,CONCAT.ERR)
    CALL F.WRITE(FN.REDO.FT.TT.REV,CONCAT.ID,R.REDO.FT.TT.REV)
*PACS00023990 - S
    CALL F.READ(FN.REDO.FT.TT.REV.REC,TODAY,R.REDO.FT.TT.REV.REC,F.REDO.FT.TT.REV.REC,REV.ERR)
    IF R.REDO.FT.TT.REV.REC THEN
        R.REDO.FT.TT.REV.REC<-1> = VAR.TXN.ID
    END ELSE
        R.REDO.FT.TT.REV.REC = VAR.TXN.ID
    END
    CALL F.WRITE(FN.REDO.FT.TT.REV.REC,TODAY,R.REDO.FT.TT.REV.REC)
*PACS00023990 - E
RETURN
*-------------------------------------------------------------------------------------------------------
END
