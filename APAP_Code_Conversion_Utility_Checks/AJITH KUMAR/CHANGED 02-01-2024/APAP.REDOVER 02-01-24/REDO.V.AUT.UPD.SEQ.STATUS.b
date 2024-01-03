* @ValidationCode : MjoxNDcxMDYyNjU3OkNwMTI1MjoxNjgyNDEyMzM4MDQwOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:38
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
SUBROUTINE REDO.V.AUT.UPD.SEQ.STATUS
*-----------------------------------------------------------------------------

*------------
*DESCRIPTION:
*-----------------------------------------------------------------------------------------
*  This routine is attached as a authorization routine for the Buy & Sell Sequence number
*  generation application and it will update REDO.BUY.SEQ.STATUS & REDO.SELL.SEQ.STATUS
*  id as AVAILABLE/ISSUED/CANCELLED and value as sequence number.
*------------------------------------------------------------------------------------------

*--------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-

*--------------
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-

*------------------
* Revision History:
*------------------
*   Date               who           Reference            Description
* 25-APR-2011       Pradeep S        PACS00053452         Initial Creation
*
*------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*10-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*10-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*---------------------------------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_F.REDO.FOREX.SEQ.NUM
$INSERT I_F.REDO.FOREX.SELL.SEQ.NUM

GOSUB INIT
GOSUB OPEN.FILES
GOSUB PROCESS

RETURN


*-----
INIT:
*-----

FN.REDO.BUY.SEQ.NO = 'F.REDO.FOREX.SEQ.NUM'
F.REDO.BUY.SEQ.NO = ''

FN.REDO.SELL.SEQ.NO = 'F.REDO.FOREX.SELL.SEQ.NUM'
F.REDO.SELL.SEQ.NO = ''

FN.REDO.BUY.SEQ.STATUS = 'F.REDO.FOREX.BUY.SEQ.STATUS'
F.REDO.BUY.SEQ.STATUS = ''

FN.REDO.SELL.SEQ.STATUS = 'F.REDO.FOREX.SELL.SEQ.STATUS'
F.REDO.SELL.SEQ.STATUS = ''


RETURN

*----------
OPEN.FILES:
*----------

CALL OPF(FN.REDO.BUY.SEQ.NO,F.REDO.BUY.SEQ.NO)
CALL OPF(FN.REDO.SELL.SEQ.NO,F.REDO.SELL.SEQ.NO)
CALL OPF(FN.REDO.BUY.SEQ.STATUS,F.REDO.BUY.SEQ.STATUS)
CALL OPF(FN.REDO.SELL.SEQ.STATUS,F.REDO.SELL.SEQ.STATUS)

RETURN


*-------
PROCESS:
*-------


BEGIN CASE

CASE APPLICATION EQ "REDO.FOREX.SEQ.NUM"
GOSUB BUY.PROCESS
CASE APPLICATION EQ "REDO.FOREX.SELL.SEQ.NUM"
GOSUB SELL.PROCESS

END CASE

RETURN

*-----------
BUY.PROCESS:
*-----------

BEGIN CASE

CASE R.NEW(REDO.FXSN.FX.SEQ.STATUS) EQ "AVAILABLE"
GOSUB BUY.AVAIL.UPD
CASE R.NEW(REDO.FXSN.FX.SEQ.STATUS) EQ "CANCELLED"
GOSUB BUY.CANCEL.UPD
END CASE

RETURN

*-------------
BUY.AVAIL.UPD:
*-------------

Y.BUY.ID = "AVAILABLE"
GOSUB READ.BUY.FILE

IF R.BUY.SEQ THEN
R.BUY.SEQ<-1> = ID.NEW
END ELSE
R.BUY.SEQ = ID.NEW
END

GOSUB WRITE.BUY.FILE

RETURN

*--------------
BUY.CANCEL.UPD:
*--------------

Y.BUY.ID.OLD = R.OLD(REDO.FXSN.FX.SEQ.STATUS)
Y.BUY.ID = Y.BUY.ID.OLD

IF Y.BUY.ID THEN
GOSUB READ.BUY.FILE
LOCATE ID.NEW IN R.BUY.SEQ SETTING BUY.POS THEN
DEL R.BUY.SEQ<BUY.POS>
GOSUB WRITE.BUY.FILE
END
END

Y.BUY.ID = "CANCELLED"

GOSUB READ.BUY.FILE

IF R.BUY.SEQ THEN
R.BUY.SEQ<-1> = ID.NEW
END ELSE
R.BUY.SEQ = ID.NEW
END

GOSUB WRITE.BUY.FILE

RETURN


*-------------
READ.BUY.FILE:
*-------------

R.BUY.SEQ = ''

*CALL F.READ(FN.REDO.BUY.SEQ.STATUS,Y.BUY.ID,R.BUY.SEQ,F.REDO.BUY.SEQ.STATUS,BUY.ERR)
CALL F.READU(FN.REDO.BUY.SEQ.STATUS,Y.BUY.ID,R.BUY.SEQ,F.REDO.BUY.SEQ.STATUS,BUY.ERR,'');* R22 AUTO CONVERSION

RETURN

*--------------
WRITE.BUY.FILE:
*--------------

CALL F.WRITE(FN.REDO.BUY.SEQ.STATUS,Y.BUY.ID,R.BUY.SEQ)

RETURN

*-----------
SELL.PROCESS:
*-----------

BEGIN CASE

CASE R.NEW(REDO.FXSN.SELL.FX.SEQ.STATUS) EQ "AVAILABLE"
GOSUB SELL.AVAIL.UPD
CASE R.NEW(REDO.FXSN.SELL.FX.SEQ.STATUS) EQ "CANCELLED"
GOSUB SELL.CANCEL.UPD
END CASE

RETURN

*-------------
SELL.AVAIL.UPD:
*-------------

Y.SELL.ID = "AVAILABLE"
GOSUB READ.SELL.FILE

IF R.SELL.SEQ THEN
R.SELL.SEQ<-1> = ID.NEW
END ELSE
R.SELL.SEQ = ID.NEW
END

GOSUB WRITE.SELL.FILE

RETURN

*--------------
SELL.CANCEL.UPD:
*--------------

Y.SELL.ID.OLD = R.OLD(REDO.FXSN.FX.SEQ.STATUS)
Y.SELL.ID = Y.SELL.ID.OLD

IF Y.SELL.ID THEN
GOSUB READ.SELL.FILE
LOCATE ID.NEW IN R.SELL.SEQ SETTING SELL.POS THEN
DEL R.SELL.SEQ<SELL.POS>
GOSUB WRITE.SELL.FILE
END
END

Y.SELL.ID = "CANCELLED"

GOSUB READ.SELL.FILE

IF R.SELL.SEQ THEN
R.SELL.SEQ<-1> = ID.NEW
END ELSE
R.SELL.SEQ = ID.NEW
END

GOSUB WRITE.SELL.FILE

RETURN


*-------------
READ.SELL.FILE:
*-------------

R.SELL.SEQ = ''

*CALL F.READ(FN.REDO.SELL.SEQ.STATUS,Y.SELL.ID,R.SELL.SEQ,F.REDO.SELL.SEQ.STATUS,SELL.ERR)
CALL F.READU(FN.REDO.SELL.SEQ.STATUS,Y.SELL.ID,R.SELL.SEQ,F.REDO.SELL.SEQ.STATUS,SELL.ERR,'');* R22 AUTO CONVERSION

RETURN

*--------------
WRITE.SELL.FILE:
*--------------

CALL F.WRITE(FN.REDO.SELL.SEQ.STATUS,Y.SELL.ID,R.SELL.SEQ)

RETURN


END
