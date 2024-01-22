* @ValidationCode : MjoxMjYyMTQzNzA0OkNwMTI1MjoxNzA0Njk3MTk5NzI3OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 08 Jan 2024 12:29:59
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
SUBROUTINE REDO.V.AUT.AA.LOAN.LOG.UPDATE
    
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : This Auth routine is used to Update the Log CR.CONTACT.LOG table
*
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RENUGADEVI B
* PROGRAM NAME : REDO.V.AUT.AA.LOAN.LOG.UPDATE
*-----------------------------------------------------------------------------------------------------
* Modification History :

*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
* 25-AUG-2010       RENUGADEVI B       ODR-2009-12-0283  INITIAL CREATION
*01-01-2024         VIGNESHWARI S      R22 MANUAL CODE CONVERSION AA.FRAMEWORK IS CHANGED 
* ----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CR.CONTACT.LOG
*$INSERT I_F.AA.ARRANGEMENT.ACTIVITY
*$INSERT I_AA.LOCAL.COMMON
$INSERT I_F.AA.CUSTOMER
   $USING AA.Framework

GOSUB INIT
GOSUB PROCESS
RETURN
*****
INIT:
*****
R.CR.CONTACT.LOG             = ''
FN.CR.CONTACT.LOG            = 'F.CR.CONTACT.LOG'
F.CR.CONTACT.LOG             = ''
CALL OPF(FN.CR.CONTACT.LOG, F.CR.CONTACT.LOG)

FN.AA.ARRANGEMENT.ACTIVITY   = 'F.AA.ARRANGEMENT.ACTIVITY'
F.AA.ARRANGEMENT.ACTIVITY    = ''
CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY, F.AA.ARRANGEMENT.ACTIVITY)

LREF.APPL                    = 'CR.CONTACT.LOG'
LREF.FIELDS                  = 'L.CR.PROD.REQ'
LREF.POS                     = ''
CALL MULTI.GET.LOC.REF(LREF.APPL, LREF.FIELDS, LREF.POS)
L.CR.PROD.REQ.POS            = LREF.POS<1,1>

RETURN
********
PROCESS:
********
*Y.ID = c_aalocArrId
Y.ID = AA.Framework.getC_aalocarrid()   ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK IS CHANGED
*CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ID,'CUSTOMER','','',RET.PROPS,RET.CONDTIONS,RET.ERR)
AA.Framework.GetArrangementConditions(Y.ID,'CUSTOMER','','',RET.PROPS,RET.CONDTIONS,RET.ERR);* R22 AUTO CONVERSION
RET.CONDTIONS = RAISE(RET.CONDTIONS)
*Y.CUST.ID = RET.CONDTIONS<AA.CUS.PRIMARY.OWNER> ;* R22 Manual conversion
Y.CUST.ID = RET.CONDTIONS<AA.CUS.CUSTOMER>
Y.INPUTTER = RET.CONDTIONS<AA.CUS.INPUTTER>
Y.SAM.TIME            = TIMEDATE()
Y.TIME                = Y.SAM.TIME[1,5]
Y.USER                = FIELD(Y.INPUTTER,'-',2)
GOSUB UPDATE.LOG
RETURN
***********
UPDATE.LOG:
***********

R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.CLIENT>                 = Y.CUST.ID
R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.STATUS>                 = "NEW"
R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.TYPE>                   = "AUTOMATICO"
R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.DESC>                   = "LOANS"
R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.CHANNEL>                = "BRANCH"
R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.DATE>                   = TODAY
R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.TIME>                   = Y.TIME
R.CR.CONTACT.LOG<CR.CONT.LOG.CONTRACT.ID>                    = Y.ID
R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.STAFF>                  = Y.USER
R.CR.CONTACT.LOG<CR.CONT.LOG.LOCAL.REF,L.CR.PROD.REQ.POS>    = "LOANS"

CALL CR.WRITE.CONTACT.LOG(R.CR.CONTACT.LOG)

RETURN
*----------------------------------------------------------------------------------------
END
