    SUBROUTINE E.APAP.BLD.VISA.OUT.REPRESENT(ENQ.DATA)

******************************************************
* Enquiry : L.APAP.REDO.ENQ.VISA.OUT.REPRESENT
* New Build routine introduced for performance
* Changes made to select with @id itself, instead of process date
******************************************************

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_ENQUIRY.COMMON


    LOCATE 'PROCESS.DATE' IN ENQ.DATA<2,1> SETTING PROCESS.DATE.POS THEN
	     DAY.NO = ''; DAY.NO = ENQ.DATA<4,PROCESS.DATE.POS>
         CALL JULDATE(DAY.NO,DAY.JUL)
         ENQ.DATA<2,PROCESS.DATE.POS> = '@ID'
		 ENQ.DATA<3,PROCESS.DATE.POS> = 'LK'
		 ENQ.DATA<4,PROCESS.DATE.POS> = 'VO':DAY.JUL[3,5]:'...'
    END

    RETURN
END