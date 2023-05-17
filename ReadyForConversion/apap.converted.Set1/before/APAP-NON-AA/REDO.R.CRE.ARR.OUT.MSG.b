*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.R.CRE.ARR.OUT.MSG(Y.REQ)
*----------------------------------------------------------------------------------------------------
* DESCRIPTION :
*              OFS.SOURCE>OUT.MSG.RTN
*              Allows for format the response that has to send to client throug TAG ofs.source in
*              REDO.CREATE.ARRANGMENT application
*-----------------------------------------------------------------------------------------------------
* Input / Output
* --------------
* IN Parameter    :  Y.REQ       ofs.response
* OUT Parameter   :
*                    Y.REQ       In case of error redo.create.arr.id/msg.id/-1,
*
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : hpasquel@temenos.com
* PROGRAM NAME : REDO.R.CRE.ARR.OUT.MSG
*-----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_EB.TRANS.COMMON
*
  Y.TXN.COMMITED = ''
  Y.OFS.RESPONSE = Y.REQ
  Y.OUT.ERR.MSG = ''
  CALL REDO.R.BULK.MAN.RESPONSE(Y.TXN.COMMITED, Y.OFS.RESPONSE, Y.OUT.ERR.MSG)
* If an error was found, then only the error messages must be informed
  IF Y.OUT.ERR.MSG NE '' THEN
    Y.REQ = Y.REQ[",",1,1]
    Y.REQ = Y.REQ["/",1,1] : "/" : Y.REQ["/",2,1] : "/"
    Y.OUT.ERR.MSG = CHANGE(Y.OUT.ERR.MSG, VM, ',')
    Y.REQ = Y.REQ : "-1/" : Y.OUT.ERR.MSG : cTxn_REQUEST_TAG_C : cTxn_REQUESTS_TAG_C
    IF NOT(INDEX(Y.REQ,"<requests>",1)) THEN
      Y.REQ = cTxn_REQUESTS_TAG : cTxn_REQUEST_TAG : Y.REQ
    END
  END ELSE
* If txn was OK, then REDO.CREATE.ARRANGEMENT ofs.response must be returned, only
    CHANGE cTxn_REQUEST_TAG_C : cTxn_REQUEST_TAG TO FM IN Y.REQ
    CHANGE cTxn_REQUESTS_TAG : cTxn_REQUEST_TAG TO '' IN Y.REQ
    CHANGE cTxn_REQUEST_TAG_C : cTxn_REQUESTS_TAG_C TO '' IN Y.REQ
    Y.REQ = cTxn_REQUESTS_TAG : cTxn_REQUEST_TAG : Y.REQ<1> : cTxn_REQUEST_TAG_C : cTxn_REQUESTS_TAG_C
  END
END
