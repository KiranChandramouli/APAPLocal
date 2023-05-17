*-----------------------------------------------------------------------------
* <Rating>-90</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TELLER.MENU.PARAM.AUTHORISE
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep M
* Program Name  : REDO.TELLER.MENU.PARAM.AUTHORISE
*-------------------------------------------------------------------------
* Description: This routine is an .AUTHORISE routine.
*-------------------------------------------------------------------------
* Linked with   :
* In parameter  :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*------------------------------------------------------------------------
*   DATE              ODR / HD REF                  DESCRIPTION
* 16-10-11            ODR-2011-08-0055
* 28-02-2012          PACS00182520                  CHANGES MADE TO WRITE AUTH CONTEXT ENQUIRY
*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CONTEXT.ENQUIRY
$INSERT I_F.REDO.TELLER.MENU.PARAM
$INSERT I_F.FUNDS.TRANSFER

  GOSUB OPEN.PROCESS

  GOSUB ASSIGN.VALUE

  GOSUB PROCESS

  RETURN

OPEN.PROCESS:
*-----------


  FN.CONTEXT.ENQUIRY='F.CONTEXT.ENQUIRY'
  F.CONTEXT.ENQUIRY=''

  CALL OPF(FN.CONTEXT.ENQUIRY,F.CONTEXT.ENQUIRY)

  FN.REDO.TELLER.MENU.PARAM='F.REDO.TELLER.MENU.PARAM'
  F.REDO.TELLER.MENU.PARAM=''

  CALL OPF(FN.REDO.TELLER.MENU.PARAM,F.REDO.TELLER.MENU.PARAM)

  APP.NAME='CONTEXT.ENQUIRY'
  OFSFUNCT='I'
  PROCESS='PROCESS'
  OFSVERSION='CONTEXT.ENQUIRY,RBHP'
  GTSMODE=''
  NO.OF.AUTH='0'
  OFSSTRING=''
  OFS.MSG.ID=''
  OFS.SOURCE='REDO.OFS.TELLER'

  OFS.ERROR=''


  RETURN


ASSIGN.VALUE:
*------------

  Y.GB.DESC='TELLER'
  Y.ENQ.JNAME='REDO.ACCT.JHOLDER'
  Y.APP.FLD='ACCOUNT.1'

  Y.APP.FLD.NAME='ACCOUNT.2'

  Y.ENQ.IMAGE='REDO.IM.CONSULTA.FIRMAS'
  Y.IM.SEL.FLD='IMAGE.REFERENCE'

  Y.PHOTO.IMAGE='REDO.ENQ.RBHP.PADRONE'
  Y.SEL.PHOTO='ACCOUNT.NO'

  Y.ENQ.DESC='ENQ TELLER'


  RETURN

PROCESS:
*-------

  Y.LAST.VER=R.OLD(TT.MENU.VERSION.NAME)

  Y.LAST.CNT=DCOUNT(Y.LAST.VER,VM)

  Y.NEW.VER=R.NEW(TT.MENU.VERSION.NAME)

  Y.NEW.CNT=DCOUNT(Y.NEW.VER,VM)

  GOSUB CHECK.PROCESS

  RETURN


CHECK.PROCESS:
*-------------

  Y.CNT=0
  LOOP
    Y.CNT+=1
  WHILE Y.CNT LE Y.NEW.CNT

    TT.POS=''

    Y.TT.VER=FIELD(Y.NEW.VER,VM,Y.CNT)

    FINDSTR Y.TT.VER IN Y.LAST.VER SETTING TT.POS THEN

    END

    IF TT.POS EQ '' THEN

      GOSUB CHECK.VER.NAME

    END

  REPEAT

  RETURN


CHECK.VER.NAME:
*--------------

  Y.CHK.NAME=Y.TT.VER[1,4]

  IF Y.CHK.NAME EQ 'FUND' THEN

    GOSUB FT.WRITE.VALUE

  END

  IF Y.CHK.NAME EQ 'TELL' THEN

    GOSUB TT.WRITE.VALUE

  END

  RETURN


TT.WRITE.VALUE:
*-------------

  Y.CTX.ENQ=Y.TT.VER:'-':Y.APP.FLD

  R.CONT.ENQUIRY=''
  ERR.CTX=''
  CALL F.READ(FN.CONTEXT.ENQUIRY,Y.CTX.ENQ,R.CONT.ENQUIRY,F.CONTEXT.ENQUIRY,ERR.CTX)

  IF R.CONT.ENQUIRY EQ '' THEN

    R.CONT.ENQUIRY<EB.CENQ.DESCRIPTION>=Y.GB.DESC
    R.CONT.ENQUIRY<EB.CENQ.ENQUIRY.NAME>=Y.ENQ.JNAME
    R.CONT.ENQUIRY<EB.CENQ.SEL.FIELD>='@ID'
    R.CONT.ENQUIRY<EB.CENQ.OPERAND>='EQ'
    R.CONT.ENQUIRY<EB.CENQ.APP.FIELD>=Y.APP.FLD
    R.CONT.ENQUIRY<EB.CENQ.ENQ.DESC>=Y.ENQ.DESC
    R.CONT.ENQUIRY<EB.CENQ.AUTO.LAUNCH>='YES'


    R.CONT.ENQUIRY<EB.CENQ.ENQUIRY.NAME,2>=Y.ENQ.IMAGE
    R.CONT.ENQUIRY<EB.CENQ.SEL.FIELD,2>=Y.IM.SEL.FLD
    R.CONT.ENQUIRY<EB.CENQ.OPERAND,2>='EQ'
    R.CONT.ENQUIRY<EB.CENQ.APP.FIELD,2>=Y.APP.FLD
    R.CONT.ENQUIRY<EB.CENQ.ENQ.DESC,2>=Y.ENQ.DESC
    R.CONT.ENQUIRY<EB.CENQ.AUTO.LAUNCH,2>='YES'

    R.CONT.ENQUIRY<EB.CENQ.ENQUIRY.NAME,3>=Y.PHOTO.IMAGE
    R.CONT.ENQUIRY<EB.CENQ.SEL.FIELD,3>=Y.SEL.PHOTO
    R.CONT.ENQUIRY<EB.CENQ.OPERAND,3>='EQ'
    R.CONT.ENQUIRY<EB.CENQ.APP.FIELD,3>=Y.APP.FLD
    R.CONT.ENQUIRY<EB.CENQ.ENQ.DESC,3>=Y.ENQ.DESC
    R.CONT.ENQUIRY<EB.CENQ.AUTO.LAUNCH,3>='YES'

    CALL F.WRITE(FN.CONTEXT.ENQUIRY,Y.CTX.ENQ,R.CONT.ENQUIRY)

    GOSUB TT.WRITE.CASH.VALUE

  END

  RETURN

TT.WRITE.CASH.VALUE:
*-------------------

  Y.CTX.ID=Y.TT.VER:'-':Y.APP.FLD.NAME

  R.CONT.ENQUIRY<EB.CENQ.APP.FIELD>=Y.APP.FLD.NAME
  R.CONT.ENQUIRY<EB.CENQ.APP.FIELD,2>=Y.APP.FLD.NAME
  R.CONT.ENQUIRY<EB.CENQ.APP.FIELD,3>=Y.APP.FLD.NAME


  CALL F.WRITE(FN.CONTEXT.ENQUIRY,Y.CTX.ID,R.CONT.ENQUIRY)

  RETURN


FT.WRITE.VALUE:
*-------------

  Y.FLD='DEBIT.ACCT.NO'

  Y.CTX.FT.ENQ=Y.TT.VER:'-':Y.FLD

  R.CONT.ENQUIRY=''
  ERR.CTX=''
  CALL F.READ(FN.CONTEXT.ENQUIRY,Y.CTX.FT.ENQ,R.CONT.ENQUIRY,F.CONTEXT.ENQUIRY,ERR.CTX)
  IF R.CONT.ENQUIRY EQ '' THEN

    R.CONT.ENQUIRY<EB.CENQ.DESCRIPTION>=Y.GB.DESC
    R.CONT.ENQUIRY<EB.CENQ.ENQUIRY.NAME>=Y.ENQ.JNAME
    R.CONT.ENQUIRY<EB.CENQ.SEL.FIELD>='@ID'
    R.CONT.ENQUIRY<EB.CENQ.OPERAND>='EQ'
    R.CONT.ENQUIRY<EB.CENQ.APP.FIELD>=Y.FLD
    R.CONT.ENQUIRY<EB.CENQ.ENQ.DESC>=Y.ENQ.DESC
    R.CONT.ENQUIRY<EB.CENQ.AUTO.LAUNCH>='YES'

    R.CONT.ENQUIRY<EB.CENQ.ENQUIRY.NAME,2>=Y.ENQ.IMAGE
    R.CONT.ENQUIRY<EB.CENQ.SEL.FIELD,2>=Y.IM.SEL.FLD
    R.CONT.ENQUIRY<EB.CENQ.OPERAND,2>='EQ'
    R.CONT.ENQUIRY<EB.CENQ.APP.FIELD,2>=Y.FLD
    R.CONT.ENQUIRY<EB.CENQ.ENQ.DESC,2>=Y.ENQ.DESC
    R.CONT.ENQUIRY<EB.CENQ.AUTO.LAUNCH,2>='YES'

    R.CONT.ENQUIRY<EB.CENQ.ENQUIRY.NAME,3>=Y.PHOTO.IMAGE
    R.CONT.ENQUIRY<EB.CENQ.SEL.FIELD,3>=Y.SEL.PHOTO
    R.CONT.ENQUIRY<EB.CENQ.OPERAND,3>='EQ'
    R.CONT.ENQUIRY<EB.CENQ.APP.FIELD,3>=Y.FLD
    R.CONT.ENQUIRY<EB.CENQ.ENQ.DESC,3>=Y.ENQ.DESC
    R.CONT.ENQUIRY<EB.CENQ.AUTO.LAUNCH,3>='YES'

    CALL F.WRITE(FN.CONTEXT.ENQUIRY,Y.CTX.FT.ENQ,R.CONT.ENQUIRY)

    GOSUB FT.WRITE.CASH.VALUE

  END

  RETURN

FT.WRITE.CASH.VALUE:
*------------------

  Y.FT.FLD='CREDIT.ACCT.NO'

  Y.CTX.FT.ID=Y.TT.VER:'-':Y.FT.FLD

  R.CONT.ENQUIRY<EB.CENQ.APP.FIELD>=Y.FT.FLD
  R.CONT.ENQUIRY<EB.CENQ.APP.FIELD,2>=Y.FT.FLD
  R.CONT.ENQUIRY<EB.CENQ.APP.FIELD,3>=Y.FT.FLD

  CALL F.WRITE(FN.CONTEXT.ENQUIRY,Y.CTX.FT.ID,R.CONT.ENQUIRY)

  RETURN

END
