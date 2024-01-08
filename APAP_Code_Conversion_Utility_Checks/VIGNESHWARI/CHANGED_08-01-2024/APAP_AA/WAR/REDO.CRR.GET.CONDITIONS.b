* @ValidationCode : MjotMTkxNzg0NDYxNzpDcDEyNTI6MTcwNDIwMDgyOTM5ODp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 Jan 2024 18:37:09
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
SUBROUTINE REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
*---------------------------------------------------------------------------
*DESCRIPTION:
*------------
* Routine to extract arrangement condition record
*----------------------------------------------------------------------------
** Input/Output:
*      IN : ARR.ID - (Arrangement ID)
*           EFF.DATE - Effective Date
*           PROP.CLASS - Property Class
*           PROPERTY - Property
*     OUT : R.Condition - Arrangement Condition
*           ERR.MSG - Error message if any, else blank
*----------------------------------------------------------------------------
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*  Date                who                            Reference                      Description
* 23-Sep-2009     Mohammed Aslam        BPCRA2009090099         Initial Creation
*--------------------------------------------------------------------------
*--------------------------------------------------------------------------
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*29-03-2023          Conversion Tool                   AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM and I++ to I=+1
*29-03-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            PACKAGE ADDED
*
*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
*$INSERT I_AA.APP.COMMON
$INSERT I_F.AA.PAYMENT.SCHEDULE
$USING AA.Framework
GOSUB INITIALISE
GOSUB GET.ARRANGEMENT.CONDITION

RETURN
*---------(Main)

INITIALISE:
*----------
ArrangementID = ARR.ID
idPropertyClass = PROP.CLASS
idProperty = PROPERTY
effectiveDate = EFF.DATE
returnIds = ''
returnConditions = ''
returnError = ''
returnVal = ''
returnFreq = ''
EngFreq = ''
PayType = ''
PAYMENT.TYPE = ''
SHORT.TYPE = ''
RTN.MSG = ''

R.Arrangement = ''
R.Err = ''
*IF effectiveDate EQ '' THEN ;*AUTO R22 CODE CONVERSION - Changed = to EQ
IF effectiveDate EQ '' THEN ;*AUTO R22 CODE CONVERSION - Changed EQ to EQ;* R22 AUTO CONVERSION
effectiveDate = TODAY
END
RETURN
*---------(Initialise)

* Call AA.GET.ARRANGEMENT.CONDITIONS to get the arrangement condition record
GET.ARRANGEMENT.CONDITION:
*-------------------------

*CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError);*R22 AUTO CONVERSION
IF returnError THEN
RTN.MSG = returnError
RETURN
END
R.Condition = RAISE(returnConditions)
RETURN
*---------(GetPaymentType)
END
